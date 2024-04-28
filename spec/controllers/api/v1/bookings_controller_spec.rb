require 'rails_helper'

RSpec.describe Api::V1::BookingsController, type: :controller do
  let(:user) { FactoryBot.create(:user, role: :customer) }
  let(:admin) { FactoryBot.create(:user, role: :admin) }

  before do
    allow(AuthorizeApiRequest).to receive(:call).and_return(user)
    allow(controller).to receive(:current_user).and_return(user)
  end

  describe '#index' do
    context 'when user is admin' do
      let!(:bookings) { create_list(:booking, 10, user: admin) }

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
      let!(:bookings) { create_list(:booking, 10, user: user) }

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
    let(:booking) { create(:booking, user: user) }

    before do
      get :show, params: { id: booking.id }
    end

    it 'assigns the requested booking to @booking' do
      expect(assigns(:booking)).to eq(booking)
    end

    it 'returns a successful response' do
      expect(response).to be_successful
    end
  end
end