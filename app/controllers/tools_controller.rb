class ToolsController < ApplicationController
  CLIENT_ID = "86865e36d3ee33d32a91"
  CLIENT_SECRET = "8bd3d5697929a2d9bf2a70d3ac5272c10cfe82d9"
  REDIRECT_URI = "http://localhost:3000/oauth2callback"
  SCOPE = ["repo", "user", "public_repo", "repo_deployment", "repo:status", "gist", "admin:gpg_key", "admin:org"]

  def index
    token = params[:token]
    @repositories = []
    if token.present?
      git = Github.new oauth_token: token
      member_name = session[:user_name]
      repos = git.repos.list
      user_name = git.users.get.login
      @repositories = Tool.repos_contain_member git, repos, user_name, member_name
    end
  end

  def create
    user_name = params[:user_name]
    session[:user_name] = user_name
    authorize
  end

  def update
    authorization_code = params[:code]
    access_token = github.get_token authorization_code
    token = access_token.token
    redirect_to tools_path(token: token)
  end

  private
  def authorize
    address = github.authorize_url redirect_uri: REDIRECT_URI, scope: SCOPE
    redirect_to address
  end

  def github
    @github ||= Github.new client_id: CLIENT_ID, client_secret: CLIENT_SECRET
  end
end
