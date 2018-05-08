class ChartsController < ApplicationController
  def camp_start
    render json: Camp.group_by_week(:start_date).count
  end
end