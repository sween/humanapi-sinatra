require 'rubygems'
require 'sinatra'
require 'omniauth-humanapi'


HUMANAPI_APP_ID =  "ecc8336266965f503e6848f50da1c51da370be9d"
HUMANAPI_APP_SECRET =  "32c75ef1f1e95987919510e87b0689202ab861fe"

use OmniAuth::Builder do
  provider :humanapi, HUMANAPI_APP_ID, HUMANAPI_APP_SECRET
end

configure do
  set :public_folder, Proc.new { File.join(root, "static") }
  enable :sessions
end

helpers do
  def username
    session[:identity] ? session[:identity] : 'Hello stranger'
  end
end

before '/secure/*' do
  if !session[:identity] then
    session[:previous_url] = request.path
    @error = 'Sorry guacamole, you need to be logged in to visit ' + request.path
    halt erb(:login_form)
  end
end

get '/' do
  erb :human_api
end

get '/login/form' do 
  erb :login_form
end

post '/login/attempt' do
  session[:identity] = params['username']
  where_user_came_from = session[:previous_url] || '/'
  redirect to where_user_came_from 
end

get '/logout' do
  session.delete(:identity)
  erb "<div class='alert alert-message'>Logged out</div>"
end


get '/secure/place' do
  erb "This is a secret place that only <%=session[:identity]%> has access to!"
end

get '/auth/humanapi/callback' do
  auth   = env['omniauth.auth']
  uid    = auth[:uid]
  email  = auth[:info][:email]
  token  = auth[:credentials][:token]
  'ok'
end