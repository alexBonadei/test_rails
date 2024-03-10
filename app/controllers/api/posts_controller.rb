class Api::PostsController < ApplicationController
  before_action :validate_search_params, only: [:search]

  def index
    @posts = Post.all

    render json: serialize_posts(@posts)
  end

  def search
    title_query = Post.where("title LIKE ?", "%#{params[:term]}%")
    tag_query = Post.joins(:tags).where(tags: { name: params[:term] })

    @posts = (title_query + tag_query).uniq

    render json: serialize_posts(@posts)
  end

  def serialize_posts(posts)
    @posts.map do |post|
      {
        title: post.title,
        id: post.id,
        tags: post.tags.map { |tag| { name: tag.name } }
      }
    end
  end

  def validate_search_params
    unless params[:term].present?
      render json: { error: "Missing 'term' parameter" }, status: :unprocessable_entity
    end
  end
end
