require 'sequel'

if ENV['environment'] == 'development'
  DB = Sequel.connect('sqlite://db/forum.db')
else
  # TODO: Add a production connection
end

Sequel::Model.plugin :json_serializer
Sequel::Model.raise_on_typecast_failure = false
Sequel::Model.raise_on_save_failure = false
require_relative 'user/models'

