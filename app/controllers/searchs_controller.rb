class SearchsController < ApplicationController
  def search
    method = params[:search_method]
    @user_or_book = params[:option]
    if @user_or_book == "1"
       @users = User.search(method, params[:search])
    else
       @books = Book.search(method, params[:search])
    end
    #binding.pry

  end
end
