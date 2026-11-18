class BoardController < ApplicationController
  def show
    @now = Time.current
    @statuses = Employee.active.order(:name).to_h { |e| [ e, e.status_at(@now) ] }
  end
end
