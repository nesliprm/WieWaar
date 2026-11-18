class Employee < ApplicationRecord
  has_many :cal_events, dependent: :destroy
  has_many :ticketdiensts, dependent: :nullify
  has_one :calendar_sync, dependent: :destroy
  normalizes :email, with: ->(email) { email.strip.downcase }
  validates :name, presence: true
  validates :email, presence: true, uniqueness: { case_sensitive: false }, format: { with: URI::MailTo::EMAIL_REGEXP }
  scope :active, -> { where(active: true) }

  STATUS_PRIORITY = %w[afwezig ziek vakantie prive bij_klant overleg thuis kantoor].freeze

  def status_at(time = Time.current)
    current = cal_events.happening_at(time).pluck(:status)
    STATUS_PRIORITY.find { |status| current.include?(status) } || "kantoor"
  end
end
