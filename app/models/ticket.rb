class Ticket < ApplicationRecord
  enum(:status, { open: 0, pending: 1, closed: 2 })

  belongs_to :customer, class_name: "User"
  belongs_to :agent, class_name: "User", optional: true
  has_many :comments, dependent: :destroy
  has_many_attached :attachments

  validates :title, presence: true, length: { minimum: 5, maximum: 100 }
  validates :description, presence: true, length: { minimum: 10 }
  validates :status, presence: true

  scope :closed_last_month, -> {
    where(status: :closed, updated_at: 1.month.ago.beginning_of_month..1.month.ago.end_of_month)
  }
  scope :open_tickets, -> { where(status: [ :open, :pending ]) }

  def can_comment?(user)
    return true if user.agent?
    comments.joins(:user).exists?(users: { role: "agent" })
  end
end
