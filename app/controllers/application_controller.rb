class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :authenticate_user

  private

    def authenticate_user
      # This is where we write the private method to authenticate user. The redirect link is derived from here: https://developer.github.com/apps/building-oauth-apps/authorizing-oauth-apps/#web-application-flow. Required parameters include client_id, but scope is also passed in to limit user's access. Read more here: https://developer.github.com/apps/building-oauth-apps/understanding-scopes-for-oauth-apps/
      redirect_to "https://github.com/login/oauth/authorize?client_id=#{ENV['GITHUB_CLIENT']}&scope=repo" if !logged_in?
    end

    def logged_in?
      # This is where we write the private method to check if user is logged in.
      !!session[:token]
    end
end
