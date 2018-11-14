class SessionsController < ApplicationController
  # Here we skip the authenticate_user before_action when we're creating a session, otherwise we'll end up in an infinite loop of trying to figure out who the user is, which is a very existential bug.
  skip_before_action :authenticate_user, only: :create

  def create
    # After we authorize the app, it generally redirects users with a temporary code that can be accessed through params, and exchanged for an access token with a second API request (either GET or POST). 
    # More here: https://developer.github.com/apps/building-oauth-apps/authorizing-oauth-apps/#web-application-flow
    # After we get the exchanged token, we can then make requests to the API.
    response = Faraday.post "https://github.com/login/oauth/access_token", {client_id: ENV["GITHUB_CLIENT"], client_secret: ENV["GITHUB_SECRET"],code: params[:code]}, {'Accept' => 'application/json'}

    access_hash = JSON.parse(response.body)
    session[:token] = access_hash["access_token"]

    # For some reason, we might also want to find out the user's username when upon authenticating. We can do that in the same method for session#create. What other key does session take?
    user_response = Faraday.get "https://api.github.com/user", {}, {'Authorization' => "token #{session[:token]}", 'Accept' => 'application/json'}

    user_json = JSON.parse(user_response.body)
    session[:username] = user_json["login"]

    redirect_to '/'
  end

end