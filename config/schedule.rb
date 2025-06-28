every :day, at: "9:00 am" do
  runner "begin; DailyTicketsReminderJob.perform_later; rescue => e; Rails.logger.error(e); end"
end
