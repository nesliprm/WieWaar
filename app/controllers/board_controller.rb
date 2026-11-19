class BoardController < ApplicationController
  def show
    @now = Time.current
    @events = Employee.active.order(:name).to_h { |e| [ e, e.current_event_at(@now) ] }
    @statuses = @events.transform_values { |event| event&.status || "kantoor" }
    @ticketdienst = Ticketdienst.on(Time.zone.today).includes(:employee).order(:raw_name)
  end
end
