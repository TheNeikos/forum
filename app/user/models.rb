require 'sequel'
require 'securerandom'

class User < Sequel::Model
  plugin :validation_helpers
  one_to_many :user_roles
  one_to_many :user_logins
  one_to_many :user_sessions

  def validate
    super
    validates_presence [:displayname, :email]
    validates_min_length 2, :displayname
    validates_format %r{^.+?@.+?\..+?$}, :email
  end
end

class UserRole < Sequel::Model
  many_to_one :user
end

class UserSession < Sequel::Model
  many_to_one :user

  def before_create
    self.expiry_date = DateTime.now + Rational(6, 24)
    self.auth_key = SecureRandom.urlsafe_base64
    super
  end

end

class UserLogin < Sequel::Model
  many_to_one :user

  def before_create
    self.expiry_date = DateTime.now + Rational(1, 24)
    self.login_key = SecureRandom.urlsafe_base64
    super
  end

  def invalidate
    self.valid = false
    self.save
  end
end
