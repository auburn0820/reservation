# frozen_string_literal: true

class Api::V1::BookingsController < ApplicationController
  before_action :set_booking, only: [:show, :destroy, :confirm, :update]
  before_action :check_exam_availability, only: [:create]
  before_action :check_cancel_exam_availability, only: [:destroy]
  before_action :check_update_booking_availability, only: [:update]

  def index
    @bookings = current_user.admin? ? Booking.all : Booking.where(user_id: current_user.user_id)
    @bookings = @bookings.page(params[:page]).per(params[:per_page])

    render_json_response(data: @bookings)
  end

  def show
    render_json_response(data: @booking)
  end

  def update
    booking_params.tap do |params|
      return render_json_response(message: "Cannot found exam", status: 404) unless Exam.exists?(exam_id: params[:exam_id])
    end

    if @booking.change_exam(booking_params[:exam_id])
      render_json_response(data: @booking)
    else
      render_json_response(message: @booking.errors.full_messages.join(', '), status: 422)
    end
  end

  def create
    @booking = Booking.build(booking_params.merge(user_id: current_user.user_id))

    if @booking.save
      render_json_response(data: @booking)
    else
      render_json_response(message: @booking.errors.full_messages.join(', '), status: 422)
    end
  end

  def destroy
    if @booking.cancel
      render_json_response(data: @booking)
    else
      render_json_response(message: @booking.errors.full_messages.join(', '), status: 422)
    end
  end

  def confirm
    return render_json_response(message: 'Only admin can confirm bookings.', status: 401) unless current_user.admin?

    if @booking.confirm
      render_json_response(data: @booking)
    else
      render_json_response(message: 'Unable to confirm booking.', status: 422)
    end
  end

  private

  def set_booking
    @booking = Booking.find_by(booking_id: params[:id], user_id: current_user.user_id)
    render_json_response(message: 'Booking not found.', status: 404) unless @booking
  end

  def check_update_booking_availability
    return render_json_response(message: "Already confirmed.", status: 422) unless @booking.is_updatable_status?
  end

  def authorized_to_cancel?
    current_user.admin? || @booking.user_id == current_user.user_id
  end

  def check_cancel_exam_availability
    return render_json_response(message: "Only the person who made the booking can cancel it.", status: 401) unless authorized_to_cancel?
    return render_json_response(message: "Already canceled.", status: 400) if @booking.is_canceled?
    return render_json_response(message: "You can only cancel a booking before it is confirmed.", status: 400) unless @booking.is_cancelable_status?
  end

  def check_exam_availability
    return render_json_response(message: "Already book the exam.", status: 422) if Booking.is_already_booked?(user_id: current_user.user_id, exam_id: booking_params[:exam_id])
    return render_json_response(message: "Already ended exam.", status: 422) if Exam.find_by(exam_id: booking_params[:exam_id]).is_already_ended?
    return render_json_response(message: "Booking must be made at least 3 days in advance.", status: 422) unless Exam.find_by(exam_id: booking_params[:exam_id]).can_apply_on_date?
    return render_json_response(message: "All spots are booked for this time slot.", status: 422) unless Booking.can_reserve_seat?(booking_params[:exam_id])
  end

  def booking_params
    params.require(:booking).permit(:exam_id)
  end
end
