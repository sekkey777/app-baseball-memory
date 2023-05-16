class GamesController < ApplicationController
  before_action :set_select_values, only: [:new, :edit]

  def new
    @game = Game.new
  end

  def index
    @games = current_user.games
  end

  def create
    @game = Game.new(game_params.merge(user_id: current_user.id))
    if @game.save
      flash[:success] = '正常に記録しました'
      redirect_to games_path
    else
      render new_game_path
    end
  end

  def show
    @game = Game.find(params[:id])
  end
  
  private

  def game_params
    params.require(:game).permit(:date, :memo, :home_team_id, :away_team_id, :baseball_park_id, :home_team_score, :away_team_score, :photo)
  end
end
