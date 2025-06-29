class ExportsController < ApplicationController
  before_action :authenticate_user_with_jwt
  before_action :ensure_agent

  def closed_tickets
    tickets = Ticket.closed_last_month
    csv_data = CSV.generate(headers: true) do |csv|
      csv << [ "ID", "Title", "Customer Email", "Agent Email", "Status", "Created At", "Closed At" ]
      tickets.each do |ticket|
        csv << [
          ticket.id,
          ticket.title,
          ticket.customer.email,
          ticket.agent&.email,
          ticket.status,
          ticket.created_at,
          ticket.updated_at
        ]
      end
    end

    send_data csv_data, filename: "closed-tickets-#{Date.today}.csv"
  end

  private

  def authenticate_user_with_jwt
    token = request.headers["Authorization"]&.remove("Bearer ")
    return head :unauthorized unless token

    begin
      decoded_token = JWT.decode(token, Rails.application.credentials.secret_key_base, true, { algorithm: "HS256" })
      user_id = decoded_token.first["sub"]
      @current_user = User.find(user_id)
    rescue JWT::DecodeError => e
      render json: { error: "Invalid token" }, status: :unauthorized
    rescue ActiveRecord::RecordNotFound => e
      render json: { error: "User not found" }, status: :unauthorized
    end
  end

  def ensure_agent
    unless @current_user&.agent?
      render json: { error: "Not authorized" }, status: :forbidden
    end
  end
end
