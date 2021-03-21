class SessionsController < ApplicationController
  def new
    logged_in?
    info = { current_user: @current_user, loggedIn: @logged_in }
    render json: info
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      log_in user                   #ログイン成功後はApp.vueではなく/Homeに移動するのでnewメソッドは利用できない
      logged_in?                    #そこで@current_userと@looged_inを取得するためにlooged_in?を追加している
      params[:session][:remember_me] == true ? remember(user) : forget(user)
      #ユーザーログイン後にsucessメッセージとuser nameをrenderする
      info = { message: 'ログインしました!', current_user: @current_user, loggedIn: @logged_in }
    else
      #ログインに失敗したらエラーメッセージをrenderする
      info = { error: ['メールアドレスまたはパスワードが正しくありません。'] }
    end
    render json: info
  end

  def destroy
    log_out if logged_in?
    logged_in?
    info = { message: 'ログアウトしました!', loggedIn: @logged_in }
    render json: info
  end

end
