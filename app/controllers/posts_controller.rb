class PostsController < ApplicationController
  def index
    # setup @source
    if params[:name] == "random"
      @source = Post.distinct.pluck(:source).sample
    else
      @source = params[:name]
    end

    # setup posts and ids for view
    @posts = Post.where(source: @source, read: nil).order(score_decayed: :desc).first(4)
    @ids   = @posts.collect { |post| post.id }

    # render using format type
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @posts }
    end
  end

  def read
    params[:ids].split(",").each do |id|
      Post.find(id.to_i).update_attributes(read: DateTime.now.utc)
    end
    render nothing: true
  end
end
