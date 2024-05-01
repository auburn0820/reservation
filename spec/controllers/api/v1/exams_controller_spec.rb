# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::ExamsController, type: :controller do
  let(:exam) { create(:exam) }
  let(:user) { create(:user) }

  before do
    allow(AuthorizeApiRequest).to receive(:call).and_return(double(result: user))
  end

  describe 'GET #index' do
    subject { get :index, params: { page: 1, per_page: 10 } }

    context 'when exam exists' do
      before do
        create_list(:exam, 11) do |exam, i|
          exam.exam_id = SecureRandom.uuid
        end
      end

      it 'returns http status success' do
        subject
        expect(response).to have_http_status(:ok)
      end

      it 'returns exams only ten if page is 1 and per_page is 10' do
        subject
        json_response = JSON.parse(response.body)
        expect(json_response['data'].size).to eq(10)
      end

      it 'returns exams only one if page is 2 any per_page more than equal 1' do
        get :index, params: { page: 2, per_page: 10 }
        json_response = JSON.parse(response.body)
        expect(json_response['data'].size).to eq(1)
      end
    end
  end
end
