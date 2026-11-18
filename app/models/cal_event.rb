class CalEvent < ApplicationRecord
  belongs_to :employee

  enum :status, {
    kantoor: "kantoor",
    thuis: "thuis",
    bij_klant: "bij_klant",
    prive: "prive",
    overleg: "overleg",
    afwezig: "afwezig",
    vakantie: "vakantie",
    ziek: "ziek"
  }, validate: true

  validates :google_event_id, presence: true
  validates :starts_at, :ends_at, presence: true
  validate :ends_after_start

  scope :happening_at, ->(time) { where("starts_at <= ? AND ends_at > ?", time, time) }

  private

  def ends_after_start
    return if starts_at.blank? || ends_at.blank?
    errors.add(:ends_at, "must be after the start") if ends_at <= starts_at
  end
end
