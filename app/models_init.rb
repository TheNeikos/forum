require 'sequel'

if ENV['environment'] == 'development'
  DB = Sequel.connect('sqlite://db/forum.db')
else
  # TODO: Add a production connection
end

Sequel::Model.plugin :json_serializer
require_relative 'user/models'

