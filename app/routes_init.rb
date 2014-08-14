
require_relative 'user/routes'
require_relative 'node/routes'

class Forum < Sinatra::Application
  get "/*" do
    haml :'index/index'
  end
end

