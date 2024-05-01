# frozen_string_literal: true

class Api::V1::ExamsController < ApplicationController
  before_action :check_admin, only: [:create, :destroy, :update]

  def index
    @exams = Exam.all.page(params[:page] || 1).per(params[:per_page] || 10).map do |exam|
      exam_json = exam.as_json
      exam_json[:count] = Booking.where(exam_id: exam.exam_id, status: Booking::Status::CONFIRMED).count
      exam_json
    end

    render_json_response(data: @exams)
  end

  def create
    @exam = Exam.new(exam_params)

    if @exam.save
      render_json_response(data: @exam)
    else
      render_json_response(message: @exam.errors.full_messages.join(', '), status: 422)
    end
  end

  def update
    @exam = Exam.find(params[:id])

    if @exam.update(exam_params)
      render_json_response(data: @exam)
    else
      render_json_response(message: @exam.errors.full_messages.join(', '), status: 422)
    end
  end

  def destroy
    @exam = Exam.find(params[:id])
    @exam.destroy

    render_json_response(data: @exam)
  end

  private

  def check_admin
    render_json_response(message: "Only admin can operate this.", status: 401) unless current_user.admin?
  end

  def exam_params
    params.require(:exam).permit(:exam_id, :name, :started_at, :ended_at)
  end
end
