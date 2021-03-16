class UsersController < ApplicationController
    def show
        @user = User.find(params[:id])
        # @user = User.find_by(name: , password[:password])
        render json: @user
    end

    def create
        @user = User.new(user_params)
        if @user.save
        else
            render json: @user.errors.full_messages
        end
    end

    private

        def user_params
            params.require(:user).permit(:name, :email, :password, :password_confirmation)
        end
end