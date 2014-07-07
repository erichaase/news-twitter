class PostsController < ApplicationController
  def index
    # setup 'feed'
    if params[:name] == "random"
      feeds = Post.select(:source).uniq.map { |p| p.source }
      feed  = feeds.sample
    else
      feed = params[:name]
    end

    # get five highest-scoring Posts
    @posts = Post.where(source: feed).order(:score).reverse_order[0,5]

    # render using format type
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @posts}
    end
  end

  def read
    render nothing: true
  end
end
