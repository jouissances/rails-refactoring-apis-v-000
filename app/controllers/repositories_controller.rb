class RepositoriesController < ApplicationController
  def index
    # We use Faraday whenever we want to retrieve info from the external API. The syntax is much simpler here, or alternatively:
    # response = Faraday.get('https://api.github.com/user/repos') do |req|
    #   req.headers['Authorization'] = 'token ' + session[:token]
    #   req.headers['Accept'] = 'application/json'
    # end

    # Here, we are retrieving a list of repositories of the logged in user. https://developer.github.com/v3/repos/#list-your-repositories
    response = Faraday.get "https://api.github.com/user/repos", {}, {'Authorization' => "token #{session[:token]}", 'Accept' => 'application/json'}

    @repos_array = JSON.parse(response.body)
  end

  def create
    # Here, we are creating a new repository for the logged in user. https://developer.github.com/v3/repos/#create
    response = Faraday.post "https://api.github.com/user/repos", {name: params[:name]}.to_json, {'Authorization' => "token #{session[:token]}", 'Accept' => 'application/json'}
    
    redirect_to '/'
  end

end
