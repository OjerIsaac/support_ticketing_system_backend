namespace :tickets do
  desc "Send daily reminder emails with open tickets to all agents"
  task send_daily_reminders: :environment do
    agents = User.where(role: "agent")
    agents.find_each do |agent|
      TicketMailer.daily_open_tickets(agent).deliver_later
      puts "Queued daily open tickets email for #{agent.email}"
    end
  end
end
