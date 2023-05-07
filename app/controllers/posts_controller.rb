class PostsController < ApplicationController
  before_action :set_select_values, only: [:top, :index, :new, :edit]

  def top
    @q = Post.ransack(params[:q])
    @posts = @q.result.page(params[:page])
  end

  def index
    @q = Post.ransack(params[:q])
    @posts = @q.result.page(params[:page])
  end

  def new
    @post = Post.new
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
  end

  private
    def post_params
      params.require(:post).permit(:title, :content, :baseball_team_id, :baseball_park_id, :category_id)
    end

end
