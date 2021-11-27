class UsersController < ApplicationController
    def new
      @user = User.new
    end
  
    private
  
    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation, :name)
    end
end