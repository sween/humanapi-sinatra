require 'rubygems'
require 'sinatra'
require 'omniauth-humanapi'
require 'humanapi'


HUMANAPI_APP_ID =  "ecc8336266965f503e6848f50da1c51da370be9d"
HUMANAPI_APP_SECRET =  "32c75ef1f1e95987919510e87b0689202ab861fe"

use OmniAuth::Builder do
  provider :humanapi, HUMANAPI_APP_ID, HUMANAPI_APP_SECRET
end

configure do
  set :public_folder, Proc.new { File.join(root, "static") }
  enable :sessions
end


get '/' do
  erb :human_api
end



get '/auth/humanapi/callback' do
  auth   = env['omniauth.auth']
  uid    = auth[:uid]
  email  = auth[:info][:email]
  token  = auth[:credentials][:token]
  
  HumanAPI::Human.token = token 
  HumanAPI::Human.profile['email'] + " <---was pulled from the HumanAPI"
  
end