require 'sequel'
require 'securerandom'

class User < Sequel::Model
  plugin :validation_helpers
  one_to_many :user_roles
  one_to_many :user_logins

  def validate
    super
    validates_presence [:displayname, :email]
    validates_min_length 2, :displayname
    validates_format %r{^.+?@.+?\..+?$}, :email
  end
end

class UserRole < Sequel::Model

end

class UserLogin < Sequel::Model
  many_to_one :user

  def before_create
    self.expiry_date = DateTime.now + Rational(1, 24)
    self.login_key = SecureRandom.urlsafe_base64
    super
  end

end
