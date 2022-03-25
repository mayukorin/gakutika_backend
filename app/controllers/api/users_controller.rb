class Api::UsersController < ApplicationController
  def create
    @user = User.new(user_params)
    if @user.save
        render json: @user, serializer: UserSerializer, status: :created
    else
        render json: @user.errors.full_messages, status: :bad_request
    end
  end

  private
    def user_params
        params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
    
end
