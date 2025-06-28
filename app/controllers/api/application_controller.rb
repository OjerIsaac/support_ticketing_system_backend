module Api
  class ApplicationController < ActionController::Base
    protect_from_forgery with: :exception

    # Optional: Add this if you want to handle API requests differently
    skip_before_action :verify_authenticity_token, if: :json_request?

    private

    def json_request?
      request.content_type == "application/json"
    end
  end
end
