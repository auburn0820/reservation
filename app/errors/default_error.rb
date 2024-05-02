# frozen_string_literal: true
class DefaultError < StandardError
  attr_reader :code, :http_status, :level

  module ERROR_LEVEL
    DEBUG = 0
    INFO = 1
    WARN = 2
    ERROR = 3
  end.freeze

  def initialize(code: 1_000, message:, http_status: :internal_server_error, level: ERROR_LEVEL::WARN)
    super(message)
    @code = code
    @http_status = http_status
    @level = level
  end
end