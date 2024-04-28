require 'rails_helper'

RSpec.describe Api::V1::BookingsController, type: :controller do
  let(:user) { FactoryBot.create(:user, role: :customer) }
  let(:admin) { FactoryBot.create(:user, role: :admin) }
  let(:exam) { FactoryBot.create(:exam) }

  before do
    allow(AuthorizeApiRequest).to receive(:call).and_return(user)
    allow(controller).to receive(:current_user).and_return(user)
  end

  describe '#index' do
    context 'when user is admin' do
      let!(:bookings) { create_list(:booking, 10, user_id: admin.user_id, exam_id: exam.exam_id) }

      before do
        allow(controller).to receive(:current_user).and_return(admin)
        get :index
      end

      it 'assigns all bookings to @bookings' do
        expect(assigns(:bookings)).to eq(bookings)
      end

      it 'returns a successful response' do
        expect(response).to be_successful
      end
    end

    context 'when user is not admin' do
      let!(:bookings) { create_list(:booking, 10, user_id: user.user_id, exam_id: exam.exam_id) }

      before do
        get :index
      end

      it 'assigns current user bookings to @bookings' do
        expect(assigns(:bookings)).to eq(bookings)
      end

      it 'returns a successful response' do
        expect(response).to be_successful
      end
    end
  end

  describe '#show' do
    let(:booking) { create(:booking, user_id: user.user_id, exam_id: exam.exam_id) }

    before do
      get :show, params: { id: booking.booking_id }
    end

    it 'assigns the requested booking to @booking' do
      expect(assigns(:booking)).to eq(booking)
    end

    it 'returns a successful response' do
      expect(response).to be_successful
    end
  end

  describe '#create' do
    context 'when availability checks pass' do

      before do
        allow(controller).to receive(:check_availability).and_return(true)
        post :create, params: { booking: { exam_id: exam.exam_id } }
      end

      it 'creates a new booking' do
        expect(Booking.where(user_id: user.user_id).size).to eq(1)
      end

      it 'assigns the new booking to @booking' do
        expect(assigns(:booking)).to eq(Booking.first)
      end

      it 'returns a successful response' do
        expect(response).to be_successful
      end
    end

    context 'when availability checks fail' do
      before do
        allow(controller).to receive(:check_availability).and_return(false)
        post :create
      end

      it 'does not create a new booking' do
        expect(Booking.where(user_id: user.user_id).size).to eq(0)
      end

      it 'returns an error response' do
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end