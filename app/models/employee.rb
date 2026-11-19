class Employee < ApplicationRecord
  has_many :cal_events, dependent: :destroy
  has_many :ticketdiensts, dependent: :nullify
  has_one :calendar_sync, dependent: :destroy
  normalizes :email, with: ->(email) { email.strip.downcase }
  validates :name, presence: true
  validates :email, presence: true, uniqueness: { case_sensitive: false }, format: { with: URI::MailTo::EMAIL_REGEXP }
  scope :active, -> { where(active: true) }

  # Statuses that put someone in exactly one zone (first match wins).
  EXCLUSIVE_STATUSES = %w[afwezig ziek vakantie prive bij_klant].freeze

  # Turns the events happening right now into the zones someone belongs to:
  # one exclusive status, or a location (kantoor/thuis) plus "overleg" when in a meeting.
  def self.statuses_for(events)
    current = events.map(&:status)
    exclusive = EXCLUSIVE_STATUSES.find { |status| current.include?(status) }
    return [ exclusive ] if exclusive

    location = current.include?("thuis") ? "thuis" : "kantoor"
    current.include?("overleg") ? [ location, "overleg" ] : [ location ]
  end

  def current_events_at(time = Time.current)
    cal_events.happening_at(time).to_a
  end

  def statuses_at(time = Time.current)
    self.class.statuses_for(current_events_at(time))
  end
end
