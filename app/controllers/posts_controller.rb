class PostsController < ApplicationController
  skip_before_action :login_required, only: [:top, :index, :show]
  before_action :set_select_values, only: [:top, :index, :new, :create, :edit]

  def top
    @q = Post.with_attached_photo.ransack(params[:q])
    @posts = @q.result.page(params[:page])
  end

  def index
    @q = Post.eager_load(:user, :baseball_team, :baseball_park, :category, :likes).with_attached_photo.ransack(params[:q])
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
      flash.now[:danger] = '投稿に失敗しました。'
      render 'new'
    end
  end

  def show
    @post = Post.find(params[:id])
  end

  private

  def post_params
    params.require(:post).permit(:title, :content, :baseball_team_id, :baseball_park_id, :category_id, :photo)
  end
end
