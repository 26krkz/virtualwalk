class UsersController < ApplicationController
    
    def create
        @user = User.new(user_params)
        if @user.save
            log_in @user
            logged_in?
            info = { message: '登録が完了しました！', current_user: @current_user, loggedIn: @logged_in}
        else
            info = { error: [@user.errors.full_messages] }
        end
        render json: info
    end

    def update
        @user = User.find(params[:id])
        if @user.update(user_params)
            logged_in?
            info = { message: 'プロフィールを変更しました！', current_user: @current_user, loggedIn: @logged_in }
        else
            info = { error: [@user.errors.full_messages] }
        end
        render json: info
    end

    def destroy
        User.find(params[:id]).destroy
        info = { message: '退会しました'}
        render json: info
    end

    #ログインしているユーザーがお気に入りした動画のvideo_idを取得
    def favorites
        current_user

        favorites = Favorite.where(user_id: @current_user.id).pluck(:video_id)
        if favorites.length != 0
            @favorite_list = Video.find(favorites)
            render json: @favorite_list
        else
            render json: {message: "does not have favorites"}
        end
    end

    #ゲストユーザーログイン
    def guest
        @user = User.new(
                         name: "ゲストユーザー",
                         email: "guest_#{SecureRandom.alphanumeric(9)}@example.com",
                         password: SecureRandom.alphanumeric(10)
                         )
        @user.save
        log_in @user
        logged_in?
        info = {message: 'ゲストユーザーでログインしました！', current_user: @current_user, loggedIn: @logged_in }
        render json:info
    end

    private

        def user_params
            params.require(:user).permit(:name, :email, :password, :password_confirmation)
        end
end
