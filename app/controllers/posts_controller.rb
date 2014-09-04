class PostsController < ApplicationController
  def index
    # setup @source
    if params[:name] == "random"
      @source = Post.distinct.pluck(:source).sample
    else
      @source = params[:name]
    end

    # setup # of days to look back
    if ndays = ENV['NEWS_SCORE_NDAYS']
      ndays = ndays.to_i
    else
      ndays = 30
    end

    # setup posts and ids for view
    @posts = Post.where("source = ? AND published > ? AND read IS ?",
                        @source,
                        DateTime.now.utc - ndays.day,
                        nil
                       ).order(score_decayed: :desc).first(4)
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
