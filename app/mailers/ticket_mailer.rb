class TicketMailer < ApplicationMailer
  def daily_open_tickets(agent)
    @agent = agent
    @open_tickets = agent.assigned_tickets.open_tickets # Only show assigned tickets
  mail(to: @agent.email, subject: "Daily Open Tickets Reminder - #{Date.current}")
  end
end
