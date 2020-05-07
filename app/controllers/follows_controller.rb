class FollowsController < ApplicationController
  def index
    @user = User.find(params[:user_id])
    @book = Book.new
    @follows = @user.followings
  end
end
