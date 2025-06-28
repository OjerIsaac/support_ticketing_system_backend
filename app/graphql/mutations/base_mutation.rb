# frozen_string_literal: true

module Mutations
  class BaseMutation < GraphQL::Schema::RelayClassicMutation
    private

    def current_user
      context[:current_user]
    end

    def authenticate!
      raise GraphQL::ExecutionError, "Authentication required" unless current_user
    end

    def authorize_agent!
      raise GraphQL::ExecutionError, "Agent authorization required" unless current_user.agent?
    end
  end
end
