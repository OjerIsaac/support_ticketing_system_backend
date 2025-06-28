class ExportsController < ApplicationController
    before_action :authenticate_user!
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

    def ensure_agent
      return if current_user.agent?
      render json: { error: "Not authorized" }, status: :forbidden
    end
end
