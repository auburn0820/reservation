# frozen_string_literal: true

class Api::V1::ExamsController < ApplicationController
  before_action :check_admin, only: [:create, :destroy, :update]
  before_action :set_exam, only: [:update, :destroy, :show]

  def index
    @exams = Exam.where(status: Exam::Status::ACTIVATED).page(params[:page] || 1).per(params[:per_page] || 10).map do |exam|
      exam_json = exam.as_json.as_json.deep_transform_keys { |key| key.to_sym }
      exam_json[:count] = Booking.where(exam_id: exam.exam_id, status: Booking::Status::CONFIRMED).count
      exam_json[:id] = exam_json[:exam_id]
      exam_json.delete(:exam_id)
      exam_json
    end

    render_json_response(data: @exams)
  end

  def show
    render_json_response(data: delete_primary_key(@exam))
  end

  def create
    @exam = Exam.new(exam_params)

    if @exam.save
      render_json_response(data: delete_primary_key(@exam))
    else
      render_json_response(message: @exam.errors.full_messages.join(', '), status: 422)
    end
  end

  def update
    if @exam.update(exam_params)
      render_json_response(data: delete_primary_key(@exam))
    else
      render_json_response(message: @exam.errors.full_messages.join(', '), status: 422)
    end
  end

  def destroy
    if @exam.set_delete
      render_json_response(data: delete_primary_key(@exam))
    else
      render_json_response(message: @exam.errors.full_messages.join(', '), status: 422)
    end
  end

  private

  def set_exam
    @exam = Exam.find_by(exam_id: params[:id], status: Exam::Status::ACTIVATED)
    render_json_response(message: 'Exam not found.', status: 404) unless @exam
  end

  def delete_primary_key(exam)
    exam_json = exam.as_json.deep_transform_keys { |key| key.to_sym }
    exam_json[:id] = exam_json[:exam_id]
    exam_json.delete(:exam_id)
    exam_json
  end

  def check_admin
    render_json_response(message: "Only admin can operate this.", status: 401) unless current_user.admin?
  end

  def exam_params
    params.require(:exam).permit(:exam_id, :name, :started_at, :ended_at)
  end
end
