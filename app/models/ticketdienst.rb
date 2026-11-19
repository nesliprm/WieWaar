class Ticketdienst < ApplicationRecord
  belongs_to :employee, optional: true

  normalizes :raw_name, with: ->(name) { name.strip }

  validates :date, :raw_name, :google_event_id, presence: true
  validates :raw_name, uniqueness: { scope: :date }

  scope :on, ->(date) { where(date: date) }
  scope :unmatched, -> { where(employee_id: nil) }
end
