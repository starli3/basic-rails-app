class VotesController < ApplicationController
  before_filter :setup   

  #before_filter sets up the instances needed for both up_vote and down_vote. We use this to make both methods DRY.

  def up_vote
    update_vote(1)
    redirect_to :back     #redirect the user to wherever he came from
  end

  def down_vote
    update_vote(-1)
    redirect_to :back
  end

  private     #we use this only when we run code/a method that is not a controller action itself. In this case, the up vote and down vote methods shouldn't be called outside of the votes controller. 

  def setup    #Because setup is called by a before_filter, the authorization with be checked every time a vote is submitted.
    @topic = Topic.find(params[:topic_id])
    @post = @topic.posts.find(params[:post_id])
    authorize! :create, Vote, message: "You need to be a user to do that."    #the setup method has authorize so that only Bloccit members can vote

    @vote = @post.votes.where(user_id: current_user.id).first
  end

  def update_vote(new_value)    #this allows the user to change his vote 
    if @vote # if it exists, update it
      @vote.update_attribute(:value, new_value)
    else # create it
      @vote = current_user.votes.create(value: new_value, post: @post)
    end
  end

end
