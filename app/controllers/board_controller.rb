class BoardController < ApplicationController
  def show
    @now = Time.current
    @statuses = Employee.active.order(:name).to_h { |e| [ e, e.status_at(@now) ] }
    @ticketdienst = Ticketdienst.on(Time.zone.today).includes(:employee).order(:raw_name)
  end
end
