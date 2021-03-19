class SessionsController < ApplicationController
  def new
    logged_in?
    data = { sucess: 'ログインしています',current_user: @current_user, loggedIn: @logged_in }
    render json: data
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      log_in user
      # current_user
      logged_in?
      #ユーザーログイン後にsucessメッセージとuser nameをrenderする
      data = { sucess: 'ログインしました!', name: user.name, current_user: @current_user, loggedIn: @logged_in }
    else
      #ログインに失敗したらエラーメッセージをrenderする
      data = { errors: ['メールアドレスまたはパスワードが正しくありません。'] }
    end
    render json: data
  end

  def destroy
    log_out
    logged_in?
    data = { sucess: 'ログアウトしました', loggedIn: @logged_in }
    render json: data
  end

end
