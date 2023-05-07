class PostsController < ApplicationController
  def index
    @q = Post.ransack(params[:q])
    @posts = @q.result
    @categories = Category.all
    @baseball_parks = BaseballPark.all
    @baseball_teams = BaseballTeam.all
  end

  def new
    @post = Post.new
    @categories = Category.all
    @baseball_parks = BaseballPark.all
    @baseball_teams = BaseballTeam.all
  end

  def create
    @post = Post.new(post_params.merge(user_id: current_user.id))
    if @post.save
      flash[:success] = "「#{@post.title}」を投稿しました"
      redirect_to posts_path
    else
      render new_post_path
    end
  end

  def show
    @post = Post.find(params[:id])
    @categories = Category.all
    @baseball_parks = BaseballPark.all
    @baseball_teams = BaseballTeam.all
  end

  def edit
    @post = Post.find(params[:id])
    @categories = Category.all
    @baseball_parks = BaseballPark.all
    @baseball_teams = BaseballTeam.all
  end

  def update
    @post = Post.find(params[:id])
    @categories = Category.all
    @baseball_parks = BaseballPark.all
    @baseball_teams = BaseballTeam.all
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
end
