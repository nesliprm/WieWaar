class Employee < ApplicationRecord
  has_many :cal_events, dependent: :destroy
  normalizes :email, with: ->(email) { email.strip.downcase }
  validates :name, presence: true
  validates :email, presence: true, uniqueness: { case_sensitive: false }, format: { with: URI::MailTo::EMAIL_REGEXP }
  scope :active, -> { where(active: true) }
end
