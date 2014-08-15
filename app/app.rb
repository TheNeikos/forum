
ENV["environment"] ||= "development"

require 'sinatra'
require 'sinatra/assetpack'
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

  register Sinatra::AssetPack

  enable :sessions

  assets do
    serve '/js', from: 'public/js'
    serve '/bower_components', from: 'public/bower_components'


    js :modernizr, [
      "/bower_components/modernizr/modernizr.js"
    ]

    js :libs, [
      "/bower_components/angular/angular.min.js",
      "/bower_components/angular-ui-router/release/angular-ui-router.min.js"
    ]

    js :application, [
      "/js/main.js",
      "/js/**/*.js"
    ]
    js_compression :jsmin

    serve '/css', from: 'public/css'

    css :framework, [
      "/bower_componentes/flatstrap/dist/flatstrap.css",
      "/bower_componentes/flatstrap/dist/flatstrap-theme.css"
    ]

    css :main, [
      '/css/**/*.css'
    ]

  end

  configure :production do
    set :haml, { :ugly => true }
    set :clean_trace, true
    set :root, File.dirname(__FILE__)
    set :app_file, __FILE__
    set :public_folder, Proc.new { File.join(File.dirname(__FILE__), 'public', 'app') }
    set :static, true
  end

  configure :development do
    # TODO: Add dev configurations
  end

  helpers do
    include Rack::Utils
    alias_method :h, :escape_html

    def json_data param
      begin
        if params[param].is_a? String
          JSON.parse params[param]
        else
          halt({ :error => "Malformed Parameters, missing json param #{param}"}.to_json)
        end
      rescue JSON::ParserError
        halt({:error => "Malformed JSON"}.to_json)
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

