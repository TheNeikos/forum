
ENV["environment"] ||= "development"

require 'sinatra'
require 'haml'

require 'json'

class Forum < Sinatra::Application

  enable :sessions

  configure :production do
    set :haml, { :ugly => true }
    set :clean_trace, true
  end

  configure :development do
    # TODO: Add dev configurations
  end

  helpers do
    include Rack::Utils
    alias_method :h, :escape_html

    def json_data param
      if params[param].is_a? String
        JSON.parse params[param]
      else
        halt({ :error => "Malformed Parameters, missing json param #{param}"}.to_json)
      end
    end

    def json_error model
      halt({ :error => "An error has occured while processing this request",
             :messages => model.errors}.to_json)
    end
  end

end

require_relative 'models_init'
require_relative 'routes_init'

