require 'sequel'

class User < Sequel::Model
  plugin :validate_helpers
  one_to_many :user_roles

  def validate
    super
    validates_presence [:displayname, :email]
    validates_min_length 2, :displayname
    validates_format %r{^.+?@.+?\..+?$}, :email
  end
end
