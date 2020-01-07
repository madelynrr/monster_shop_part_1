class UsersController < ApplicationController
  def new
    @user = User.new(user_params)
  end

  def create
    @user = User.create(user_params)
    if @user.save
      flash[:success] = "Welcome, #{@user.name}! You're now registered!"
      session[:user_id] = @user.id
      redirect_to '/profile'
    else
      flash[:error] = @user.errors.full_messages.to_sentence
      render :new
    end
  end

  def show
    if current_user
      @user = User.find(session[:user_id])
    else
      render file: '/public/404'
    end
  end

  def edit
    @user = User.find(session[:user_id])
  end

  def update
    @user = User.find(session[:user_id])
      @user.update(user_params)
      update_profile
  end



  private
  def user_params
    params.permit(:name, :address, :city, :state, :zip_code, :email, :password, :password_confirmation)
  end

  def update_profile
    if @user.save
      flash[:success] = "You have successfully edited your profile!"
      redirect_to '/profile'
    else
      flash[:error] = @user.errors.full_messages.to_sentence
      render :edit
    end
  end
end
