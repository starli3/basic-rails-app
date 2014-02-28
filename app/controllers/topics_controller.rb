class TopicsController < ApplicationController
  def index
    ## @topics = Topic.all - this line was removed as requested by the Pagination checkpoint. 
    @topics = Topic.paginate(page: params[:page], per_page: 10) #this line was added from Pagination checkpoint. 
  end

  def new
    @topic = Topic.new
    authorize! :create, @topic, message: "You need to be an admin to do that."
  end

  def show
    @topic = Topic.find(params[:id])
    @posts = @topic.posts.paginate(page: params[:page], per_page: 10)  ## calling paginate on collection of posts. We are instructing paginate to render 10 posts/topic per page.
    ## @posts = @topic.posts (this line was removed as requested by Pagination checkpoint).
  end

  def edit
    @topic = Topic.find(params[:id])
    authorize! :update, @topic, message: "You need to be an admin to do that."
  end

  def create
    @topic = Topic.new(params[:topic])
    authorize! :create, @topic, message: "You need to be an admin to do that."
    if @topic.save
      redirect_to @topic, notice: "Topic was saved successfully."
    else
      flash[:error] = "Error creating topic. Please try again."
      render :new
    end
  end

  def destroy
    @topic = Topic.find(params[:id]) ##We are simply grabbing the topic to destroy. 
    name = @topic.name       
    authorize! :destroy, @topic, message: "You need to own the topic to delete it."
    if @topic.destroy      ##Just like save, this will return true or false based on whether or not the topic was successfully deleted.
      flash[:notice] = "\"#{name}\" was deleted successfully."
      redirect_to topics_path
    else
      flash[:error] = "There was an error deleting the topic."
      render :show
    end
  end

  def update
    @topic = Topic.find(params[:id])
    authorize! :update, @topic, message: "You need to own the topic to update it."
    if @topic.update_attributes(params[:topic])
      redirect_to @topic, notice: "Topic was saved successfully."
    else
      flash[:error] = "Error saving topic. Please try again"
      render :edit
    end
  end
end