require 'sinatra'

set :views, './views'

get '/' do
  haml :index
end
