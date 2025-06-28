class Comment < ApplicationRecord
  belongs_to :ticket
  belongs_to :user
  has_many_attached :attachments

  validates :content, presence: true, length: { minimum: 2 }
  validate :customer_can_only_comment_if_agent_has_commented

  after_create :update_ticket_status_if_agent

  private

  def customer_can_only_comment_if_agent_has_commented
    if user.customer? && !ticket.comments.exists?(user: ticket.agent)
      errors.add(:base, "Customer can only comment after an agent has responded")
    end
  end

  def update_ticket_status_if_agent
    if user.agent? && ticket.open?
      ticket.update(status: :in_progress)
    end
  end
end
