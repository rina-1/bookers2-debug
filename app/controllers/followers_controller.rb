class FollowersController < ApplicationController
  def index
  	@user = User.find(params[:user_id])
  	@book = Book.new
 	@followers = @user.reverse_of_relationships
  end
end
