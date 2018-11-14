class GithubRepo
# We are not inheriting from ActiveRecord::Base because we are not dealing with our own database here.

  attr_reader :name, :url

  def initialize(hash)
    @name = hash["name"]
    @url = hash["html_url"]
  end

end