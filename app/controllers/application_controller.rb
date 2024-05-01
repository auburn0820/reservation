class ApplicationController < ActionController::API
  before_action :authenticate_request
  attr_reader :current_user
  rescue_from StandardError, with: :handle_error

  private

  def authenticate_request
    command = AuthorizeApiRequest.call(request.headers)
    @current_user = command.result

    unauthorized_response unless @current_user
  end

  def unauthorized_response
    render_json_response(code: 1000, message: 'Unauthorized', status: :unauthorized)
  end

  def render_json_response(code: 0, message: "", data: nil, status: :ok)
    render json: { code: code, message: message, data: data }, status: status
  end

  def handle_error(e)
    status = :bad_request
    render json: { code: Rack::Utils::SYMBOL_TO_STATUS_CODE[status], message: e.message, data: nil }, status: status
  end

  def set_error_response(e)
    case e
    when DefaultError
      render_json_response(code: 1001, message: e.message, status: e.error_status)
    else
      render_json_response(code: 1, message: "에러가 발생하였습니다.", status: :internal_server_error)
    end
  end
end