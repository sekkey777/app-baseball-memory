class GamesController < ApplicationController
  before_action :set_game, only: [:show, :edit, :update, :destroy]
  before_action :set_select_values, only: [:new, :edit, :create, :update, :destroy]
  before_action :set_beginning_of_week, only: [:index]

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
      flash.now[:danger] = '記録に失敗しました。'
      render new_game_path
    end
  end

  def show
  end

  def edit
  end

  def update
    if @game.update(game_params)
      flash[:success] = '投稿内容を更新しました'
      redirect_to games_path
    else
      flash.now[:danger] = '更新に失敗しました。'
      render 'edit'
    end
  end

  def destroy
    @game.destroy
    flash[:success] = "「#{@game.home_team.name}」 vs 「#{@game.away_team.name}」の観戦記録を削除しました"
    redirect_to games_path
  end

  private

  def game_params
    params.require(:game).permit(:date, :memo, :home_team_id, :away_team_id, :baseball_park_id, :home_team_score,
:away_team_score, :photo)
  end

  def set_game
    @game = current_user.games.find(params[:id])
  end

  def set_beginning_of_week
    Date.beginning_of_week = :sunday
  end
end
