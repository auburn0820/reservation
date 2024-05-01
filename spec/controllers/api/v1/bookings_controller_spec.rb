require 'rails_helper'

RSpec.describe Api::V1::BookingsController, type: :controller do
  let(:user) { create(:user) }
  let(:admin_user) { create(:user, :admin) }
  let(:exam) { create(:exam) }
  let(:booking) { create(:booking, user_id: user.user_id, exam_id: exam.exam_id) }

  before do
    allow(AuthorizeApiRequest).to receive(:call).and_return(double(result: user))
  end

  describe 'GET #index' do
    subject { get :index }

    before do
      booking
    end

    it 'returns 200 status' do
      subject
      expect(response).to have_http_status(200)
    end

    it 'returns correct booking' do
      subject
      json_response = JSON.parse(response.body)
      expect(json_response['data'].size).to eq(1)
      expect(json_response['data'][0]['id']).to eq(booking.booking_id)
    end
  end

  describe 'POST #create' do
    subject { post :create, params: { booking: { exam_id: exam.exam_id } } }

    context 'when eaxam is more than 3 days away' do
      let(:exam) { create(:exam, started_at: Time.current + 4.days) }

      it 'returns 200 status' do
        subject
        expect(response).to have_http_status(200)
      end
    end

    context 'when exam is less than 3 days away' do
      let(:exam) { create(:exam, started_at: Time.current + 1.days) }

      it 'returns 422 status' do
        subject
        expect(response).to have_http_status(422)
      end
    end

    context 'when exam is already booked' do
      let(:booking) { create(:exam, user_id: user.user_id) }

      it 'returns 422 status' do
        subject
        expect(response).to have_http_status(422)
      end
    end

    context 'when exam is no spots' do
      before do
        allow(Booking).to receive(:can_reserve_seat?).and_return(false)
      end

      it 'returns 422 status' do
        subject
        expect(response).to have_http_status(422)
      end
    end

    context 'when exam is already end' do
      before do
        exam.update(started_at: Time.current - 1.days, ended_at: Time.current - 1.days + 1.hours)
      end

      it 'returns 422 status' do
        subject
        expect(response).to have_http_status(422)
      end

      it 'not create booking' do
        expect { subject }.not_to change(Booking, :count)
      end
    end
  end

  describe 'DELETE #destroy' do
    subject { delete :destroy, params: { id: booking.booking_id } }

    context 'when the booking can be canceled' do
      before do
        allow(booking).to receive(:cancel).and_return(true)
      end

      it 'destroys the booking' do
        expect { subject }.to change(Booking, :count).by(0)
      end

      it 'returns a success response' do
        subject
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when the user is not authorized to cancel the booking' do
      before do
        allow_any_instance_of(Api::V1::BookingsController).to receive(:authorized_to_cancel?).and_return(false)
      end

      it 'does not destroy the booking' do
        expect { subject }.to_not change { booking.reload.status }
      end

      it 'returns an unauthorized response' do
        subject
        expect(response).to have_http_status(401)
      end
    end
  end

  describe 'GET #show' do
    before do
      booking
    end

    subject { get :show, params: { id: booking.booking_id } }

    it 'returns http success' do
      subject
      expect(response).to have_http_status(:success)
    end

    it 'returns the expected booking' do
      subject
      expect(JSON.parse(response.body)['data']).to eq(booking.as_json.then do |booking|
        booking['id'] = booking.delete('booking_id')
        booking
      end)
    end

    context 'when another user request not his booking' do
      before do
        booking.update(user_id: SecureRandom.uuid)
      end

      it 'returns 404 status' do
        subject
        expect(response).to have_http_status(404)
      end
    end
  end

  describe 'POST #confirm' do
    before do
      booking
    end

    subject { post :confirm, params: { id: booking.booking_id } }

    context 'when admin user confirm booking' do
      before do
        user.update(role: User::Role::ADMIN)
      end
      it 'returns http success' do
        subject
        expect(response).to have_http_status(:success)
      end
    end

    context 'when customer user confirm booking' do
      before do
        user.update(role: User::Role::CUSTOMER)
      end
      it 'returns http 401' do
        subject
        expect(response).to have_http_status(401)
      end
    end
  end

  describe 'PUT #update' do
    before do
      exam
      booking.update(exam_id: SecureRandom.uuid)
    end

    subject { put :update, params: { id: booking.booking_id, booking: { exam_id: exam.exam_id } } }

    context 'when exam exists' do
      it 'returns http success' do
        subject
        expect(response).to have_http_status(:success)
      end

      it 'change exam_id of booking' do
        expect { subject }.to change { booking.reload.exam_id }
      end
    end

    context 'when exam does not exists' do
      before do
        exam.destroy
      end

      it 'returns http 404' do
        subject
        expect(response).to have_http_status(404)
      end

      it 'does not change exam_id of booking' do
        expect { subject }.not_to change { booking.reload.exam_id }
      end
    end

    context 'when booking is already confirmed' do
      before do
        booking.update(status: Booking::Status::CONFIRMED)
      end

      it 'returns http 422' do
        subject
        expect(response).to have_http_status(422)
      end

      it 'does not change booking' do
        expect { subject }.not_to change { booking.reload.exam_id }
      end
    end
  end
end