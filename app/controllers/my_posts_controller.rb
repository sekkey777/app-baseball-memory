class MyPostsController < ApplicationController
  before_action :set_my_post, only: [:show, :edit, :update]
  before_action :set_select_values, only: [:index, :edit, :update]

  def index
    @q = current_user.posts.ransack(params[:q])
    @posts = @q.result.page(params[:page])
  end

  def show
  end

  def edit
  end

  def update
    if @post.update(post_params)
      flash[:success] = '投稿内容を更新しました'
      redirect_to post_path(@post)
    else
      render 'new'
    end
  end
  
  private
    def post_params
      params.require(:post).permit(:title, :content, :baseball_team_id, :baseball_park_id, :category_id)
    end

    def set_my_post
      @post = current_user.posts.find(params[:id])
    end

    def set_select_values
      @categories = Category.all
      @baseball_parks = BaseballPark.all
      @baseball_teams = BaseballTeam.all
    end
end
