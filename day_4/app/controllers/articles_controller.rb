class ArticlesController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_article, only: [:show, :edit, :update, :destroy, :report]
  before_action :authorize_user!, only: [:edit, :update, :destroy]

  def index
  @articles = Article.where(status: [nil, 'active'])
  end

  def show
  end

  def new
    @article = current_user.articles.new
  end

  def edit
  end

  def create
    @article = current_user.articles.new(article_params)
    if @article.save
      redirect_to @article, notice: 'Article created successfully.'
    else
      render :new, alert: 'Failed to create article.'
    end
  end

  def update
    if @article.update(article_params)
      redirect_to @article, notice: 'Article updated successfully.'
    else
      render :edit, alert: 'Failed to update article.'
    end
  end

  def destroy
    @article.destroy
    redirect_to articles_path, notice: 'Article deleted successfully.'
  end

  def report
    @article.increment!(:reports_count)
    if @article.reports_count >= 3
      @article.update(status: 'archived')
    end
    redirect_to @article, notice: 'Article reported successfully.'
  end

  private

  def set_article
    @article = Article.find(params[:id])
  end

  def authorize_user!
    redirect_to articles_path, alert: 'Not authorized.' unless @article.user == current_user
  end

  def article_params
    params.require(:article).permit(:title, :content, :image)
  end
end