class CalendarSync < ApplicationRecord
  belongs_to :employee, optional: true

  validates :google_calendar_id, presence: true, uniqueness: true

  scope :ticketdienst, -> { where(employee_id: nil) }
  scope :channel_expiring, -> { where(channel_expires_at: ..1.day.from_now) }

  def ticketdienst?
    employee_id.nil?
  end
end
