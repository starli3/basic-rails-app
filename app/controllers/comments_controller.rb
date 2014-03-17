class CommentsController < ApplicationController
  respond_to :html, :js
  def create
    @topic = Topic.find(params[:topic_id])  ##finds the current topic by using the ID that's in the prameters and stores that in @topic
    @post = @topic.posts.find(params[:post_id])  ##this line finds the post based on the params, just like the line above, except within in the scope of topics
    #@post = Post.find(params[:post_id])  could also be written like this

    @comment = current_user.comments.build(params[:comment])   ##first line builds a comment in the context of the current_user and the params@comment.post = @post   ##second line adds the post_id to the comment (before you save)
    @comment.post = @post  ##second line adds the post_id to the comment (before you save)

    authorize! :create, @comment, message: "You need be signed in to do that."
    if @comment.save
      redirect_to [@topic, @post], notice: "Comment was saved successfully"
    else
      flash[:error] = "There was an error saving the comment. Please try again."
      render :new
    end
  end

  def destroy
    @topic = Topic.find(params[:topic_id])
    @post = @topic.posts.find(params[:post_id])

    @comment = @post.comments.find(params[:id])
    authorize! :destroy, @comment, message: "You need to own the comment to delete it."
    
    if @comment.destroy
      flash[:notice] = "Comment was removed."
    else
      flash[:error] = "Comment couldn't be deleted. Try again."

    respond_with(@comment) do |f|
      f.html { redirect_to [@topic, @post]}
    end
    end
  end
end