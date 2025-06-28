class DailyTicketsReminderJob < ApplicationJob
  queue_as :default

  def perform
    User.agent.each do |agent|
      TicketMailer.daily_open_tickets(agent).deliver_later
    end
  rescue => e
    Rails.logger.error "Failed to send reminders: #{e.message}"
    raise
  end
end
