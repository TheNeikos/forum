require 'sequel'

class User < Sequel::Model
  one_to_many :user_roles
end
