
ENV["environment"] ||= "development"

require 'sinatra'
require 'haml'

require 'json'
require 'pony'

Pony.options = {
  :via => :smtp,
  :via_options => {
    :address              => 'smtp.gmail.com',
    :port                 => '587',
    :enable_starttls_auto => true,
    :user_name            => ENV["EMAIL_USER"],
    :password             => ENV["EMAIL_PASSWORD"],
    :authentication       => :plain, # :plain, :login, :cram_md5, no auth by default
    :domain               => "localhost.localdomain" # the HELO domain provided by the client to the server
  }
}



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

    def json_error errors
      halt({ :error => "An error has occured while processing this request",
             :messages => errors}.to_json)
    end
  end

end


require_relative 'models_init'
require_relative 'helpers_init'
require_relative 'routes_init'

