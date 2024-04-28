# frozen_string_literal: true
class DefaultError < StandardError
  attr_reader :error_status

  def initialize(message:, error_status: :internal_server_error)
    super(message)
    @error_status = error_status
  end
end