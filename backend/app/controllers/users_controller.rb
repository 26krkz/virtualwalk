class UsersController < ApplicationController
    def show
        @user = User.find(params[:id])
        render json: @user
    end

    def create
        @user = User.new(user_params)
        if @user.save
            log_in @user
            logged_in?
            data = { sucess: '登録が完了しました!', current_user: @current_user, loggedIn: @logged_in}
        else
            data = { error: [@user.errors.full_messages] }
        end
        render json: data
    end

    private

        def user_params
            params.require(:user).permit(:name, :email, :password, :password_confirmation)
        end
end
