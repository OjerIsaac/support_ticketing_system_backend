class TicketMailer < ApplicationMailer
  def daily_open_tickets(agent)
    @agent = agent
    @open_tickets = agent.assigned_tickets.where(status: "open")

    mail(
      to: @agent.email,
      subject: "Daily Open Tickets Reminder - #{Date.current}"
    )
  end
end
