class BoardController < ApplicationController
  def show
    @now = Time.current
    @employees = Employee.active.order(:name)
  end
end
