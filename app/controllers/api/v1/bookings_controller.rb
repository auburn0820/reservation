# frozen_string_literal: true

class Api::V1::BookingsController < ApplicationController
  before_action :set_reservation, only: [:show]

  def index
    if current_user.admin?
      @bookings = Booking.all.page(params[:page]).per(params[:per_page])
    else
      @bookings = current_user.bookings.page(params[:page]).per(params[:per_page])
    end

    render_json_response(data: @bookings)
  end

  def show
    render_json_response(data: @booking)
  end

  private

  def set_reservation
    @booking = Booking.find(params[:id])
  end
end
