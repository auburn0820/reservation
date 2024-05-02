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

  def handle_default_error(e)
    logging_default_error(e)
    render json: { code: e.code, message: e.message, data: nil }, status: e.http_status
  end

  def handle_error(e)
    case (e)
    when DefaultError
      logging_default_error(e)
      render json: { code: e.code, message: e.message, data: nil }, status: e.http_status
    else
      status = :internal_server_error
      render json: { code: Rack::Utils::SYMBOL_TO_STATUS_CODE[status], message: e.message, data: nil }, status: status
    end
  end

  def logging_default_error(e)
    case (e.level)
    when DefaultError::ERROR_LEVEL::DEBUG
      Rails.logger.debug(e.message)
    when DefaultError::ERROR_LEVEL::INFO
      Rails.logger.debug(e.message)
    when DefaultError::ERROR_LEVEL::WARN
      Rails.logger.debug(e.message)
    when DefaultError::ERROR_LEVEL::ERROR
      Rails.logger.debug(e.message)
    else
      Rails.logger.error(e.message)
    end
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