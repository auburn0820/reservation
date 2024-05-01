# frozen_string_literal: true

class Api::V1::ExamsController < ApplicationController

  def index
    @exams = Exam.all.page(params[:page]).per(params[:per_page])

    render_json_response(data: @exams)
  end
end
