class UsersController < ApplicationController
  def new
  	@user = User.new
  end
  def show
  	@user = User.find(params[:id])
  end
  def create
  	@user = User.new(params[:user])
  	if @user.save
  		# Handle a successful save.
      sign_in @user
  		flash[:success] = "Welcome to the Group Ride!"
  		redirect_to @user
  	else
  		render 'new'
  	end
  end
end
