class ApplicationController < ActionController::Base
  include SessionsHelper

  def set_select_values
    @categories = Category.all
    @baseball_parks = BaseballPark.all
    @baseball_teams = BaseballTeam.all
  end
end
