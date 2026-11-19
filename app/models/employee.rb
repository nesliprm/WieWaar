class Employee < ApplicationRecord
  has_many :cal_events, dependent: :destroy
  has_many :ticketdiensts, dependent: :nullify
  has_one :calendar_sync, dependent: :destroy
  normalizes :email, with: ->(email) { email.strip.downcase }
  validates :name, presence: true
  validates :email, presence: true, uniqueness: { case_sensitive: false }, format: { with: URI::MailTo::EMAIL_REGEXP }
  scope :active, -> { where(active: true) }

  STATUS_PRIORITY = %w[afwezig ziek vakantie prive bij_klant overleg thuis kantoor].freeze

  def current_event_at(time = Time.current)
    events = cal_events.happening_at(time).to_a
    STATUS_PRIORITY.each do |status|
      event = events.find { |e| e.status == status }
      return event if event
    end
    nil
  end

  def status_at(time = Time.current)
    current_event_at(time)&.status || "kantoor"
  end
end
