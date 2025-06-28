# frozen_string_literal: true

module Api
  class GraphqlController < ApplicationController
    protect_from_forgery with: :null_session

    def execute
      variables = prepare_variables(params[:variables])
      query = params[:query]
      operation_name = params[:operationName]
      context = {
        current_user: current_user_from_token
      }
      result = SupportTicketingSystemBackendSchema.execute(
        query,
        variables: variables,
        context: context,
        operation_name: operation_name
      )
      render json: result
    rescue StandardError => e
      handle_error_in_development(e)
    end

    private

    def current_user_from_token
      auth_header = request.headers["Authorization"]
      return nil if auth_header.blank?

      token = auth_header.split(" ").last
      decoded = JWT.decode(token, Rails.application.secret_key_base)[0]
      User.find_by(id: decoded["sub"])
    rescue JWT::DecodeError
      nil
    end

    def prepare_variables(variables_param)
      case variables_param
      when String
        variables_param.present? ? JSON.parse(variables_param) : {}
      when Hash
        variables_param
      when ActionController::Parameters
        variables_param.to_unsafe_hash
      else
        {}
      end
    end

    def handle_error_in_development(e)
      logger.error e.message
      logger.error e.backtrace.join("\n")

      render json: { errors: [{ message: e.message, backtrace: e.backtrace }], data: {} }, status: 500 # rubocop:disable Layout/SpaceInsideArrayLiteralBrackets
    end
  end
end
