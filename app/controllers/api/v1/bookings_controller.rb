# frozen_string_literal: true

class Api::V1::BookingsController < ApplicationController
  before_action :set_booking, only: [:show]
  before_action :check_availability, only: [:create]

  def index
    bookings = if current_user.admin?
                 Booking.all
               else
                 Booking.where(user_id: current_user.user_id)
               end

    @bookings = bookings.page(params[:page]).per(params[:per_page])

    render_json_response(data: @bookings)
  end

  def show
    render_json_response(data: @booking)
  end

  def create
    if check_availability
      @booking = Booking.new(booking_params.merge(user_id: current_user.user_id))

      if @booking.save
        render_json_response(data: @booking)
      else
        render_json_response(message: @booking.errors.full_messages.join(', '), status: 422)
      end
    else
      render_json_response(message: 'Booking limit reached for this time slot', status: 422)
    end
  end

  def confirm
    if current_user.admin?
      @booking = Booking.find_by(booking_id: params[:id])

      if @booking&.confirm
        render_json_response(data: @booking)
      else
        render_json_response(message: @booking.errors.full_messages.join(', '), status: 422)
      end
    else
      render_json_response(message: 'Only admin confirm booking.', status: 401)
    end
  end

  private

  def set_booking
    # only allow fetching own booking unless admin
    @booking = current_user.admin? ? Booking.find(params[:id]) : Booking.find_by(booking_id: params[:id], user_id: current_user.user_id)
  end

  def check_availability
    Booking.where(booked_at: params[:exam_id], confirmed: true).count < 50_000
  end

  def booking_params
    params.require(:booking).permit(:exam_id)
  end
end
