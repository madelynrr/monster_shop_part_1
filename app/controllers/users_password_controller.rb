class UsersPasswordController < ApplicationController

    def edit
    end

    def update
        if params[:password] == params[:password_confirmation]
            current_user.update(user_params)
            redirect_to "/profile"
            flash[:notice] = "Your password has been updated."
        elsif params[:password] != params[:password_confirmation]
            redirect_to "/user/password/edit"
            flash[:error] = "Password and password confirmation do not match."
        end
    end

private 
    def user_params
    params.permit(:name, :address, :city, :state, :zip_code, :email, :password, :password_confirmation)
    end
end
