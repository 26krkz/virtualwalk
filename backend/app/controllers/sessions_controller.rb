class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(name: params[:session][:name].downcase)
    if user && user.authenticate(params[:session][:password])
      #ユーザーログイン後にsucessメッセージとuser nameをrenderする
      log_in user
      current_user
      logged_in?
      data = { sucess: 'ログインしました!', name: user.name, current_user: @current_user, loggedIn: @logged_in }
    else
      #ログインに失敗したらエラーメッセージをrenderする
      data = { errors: ['メールアドレスまたはパスワードが正しくありません。'] }
    end
    render json: data
  end

  def destroy
  end

end
