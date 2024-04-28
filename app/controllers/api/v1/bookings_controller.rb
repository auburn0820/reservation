# frozen_string_literal: true

class Api::V1::BookingsController < ApplicationController
  before_action :set_booking, only: [:show, :destroy, :confirm]
  before_action :check_exam_availability, only: [:create]

  def index
    @bookings = current_user.admin? ? Booking.all : Booking.where(user_id: current_user.user_id)
    @bookings = @bookings.page(params[:page]).per(params[:per_page])

    render_json_response(data: @bookings)
  end

  def show
    render_json_response(data: @booking)
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
    return render_json_response(message: "Only the person who made the booking can cancel it.", status: 400) unless authorized_to_cancel?

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
    @booking = Booking.find_by(booking_id: params[:id])
    render_json_response(message: 'Booking not found.', status: 404) unless @booking
  end

  def authorized_to_cancel?
    current_user.admin? || @booking.user_id == current_user.user_id && @booking.status != "confirmed"
  end

  def check_exam_availability
    render_json_response(message: "Can't booking.", status: 422) unless can_book_exam?
  end

  def can_book_exam?
    Booking.where(exam_id: booking_params[:exam_id], status: "confirmed").count < Constants::BOOKING_LIMIT_COUNT
  end

  def booking_params
    params.require(:booking).permit(:exam_id)
  end
end
