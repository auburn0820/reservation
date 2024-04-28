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
    context '사용자가 관리자일 때' do
      let!(:bookings) { create_list(:booking, 10, user_id: admin.user_id, exam_id: exam.exam_id) }

      before do
        allow(controller).to receive(:current_user).and_return(admin)
        get :index
      end

      it '@bookings에 모든 예약이 할당됨' do
        expect(assigns(:bookings)).to eq(bookings)
      end

      it '성공 응답 반환' do
        expect(response).to be_successful
      end
    end

    context '사용자가 관리자가 아닐 때' do
      let!(:bookings) { create_list(:booking, 10, user_id: user.user_id, exam_id: exam.exam_id) }

      before do
        get :index
      end

      it '@bookings에 현재 사용자의 예약만 할당됨' do
        expect(assigns(:bookings)).to eq(bookings)
      end

      it '성공 응답 반환' do
        expect(response).to be_successful
      end
    end
  end

  describe '#show' do
    let(:booking) { create(:booking, user_id: user.user_id, exam_id: exam.exam_id) }

    before do
      get :show, params: { id: booking.booking_id }
    end

    it '요청된 예약을 @booking에 할당함' do
      expect(assigns(:booking)).to eq(booking)
    end

    it '성공 응답 반환' do
      expect(response).to be_successful
    end
  end

  describe '#create' do
    context '예약할 수 있는 상황이면' do

      before do
        allow(controller).to receive(:check_availability).and_return(true)
        post :create, params: { booking: { exam_id: exam.exam_id } }
      end

      it '새로운 예약을 생성함' do
        expect(Booking.where(user_id: user.user_id).size).to eq(1)
      end

      it '새롭게 생성된 예약을 @booking에 할당함' do
        expect(assigns(:booking)).to eq(Booking.first)
      end

      it '성공적인 응답을 반환함' do
        expect(response).to be_successful
      end
    end

    context '예약을 할 수 없는 상황이면' do
      before do
        allow(controller).to receive(:check_availability).and_return(false)
        post :create
      end

      it '새로운 예약은 생성하지 않음' do
        expect(Booking.where(user_id: user.user_id).size).to eq(0)
      end

      it '오류 응답 반환' do
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'PUT confirm' do
    let(:booking) { create(:booking, user_id: user.user_id, exam_id: exam.exam_id) }

    context '사용자가 관리자일 때' do
      before do
        allow(controller).to receive(:current_user).and_return(admin)
        put :confirm, params: { id: booking.booking_id }
      end

      it '예약을 확정한다' do
        expect(booking.reload.confirmed).to eq(true)
      end

      it '성공 응답 반환' do
        expect(response).to have_http_status(:success)
      end
    end

    context '사용자가 관리자가 아닐 때' do
      before do
        allow(controller).to receive(:current_user).and_return(user)
        put :confirm, params: { id: booking.booking_id }
      end

      it '예약 확정을 할 수 없다' do
        expect(booking.reload.confirmed).to eq(false)
      end

      it '권한 없음 상태를 반환' do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end