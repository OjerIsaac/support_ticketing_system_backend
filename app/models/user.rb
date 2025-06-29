class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  enum(:role, { customer: 0, agent: 1 })

  has_many :authored_tickets, class_name: "Ticket", foreign_key: "customer_id"
  has_many :assigned_tickets, class_name: "Ticket", foreign_key: "agent_id"
  has_many :comments

  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :role, presence: true

  def display_name
    email.split("@").first.titleize
  end

  def generate_jwt
    payload = {
      sub: id,
      exp: 4.hours.from_now.to_i,
      role: role
    }
    JWT.encode(payload, Rails.application.secret_key_base)
  end
end
