require 'sinatra'

set :views, './views'
set :public_folder, './public'

get '/' do
  haml :index
end
