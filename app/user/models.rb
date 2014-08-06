require 'sequel'
require 'securerandom'
require 'digest'

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

  def verify_password password
    self.password_hash == Digest::SHA512.hexdigest(self.password_salt + password)
  end

  def self.login_with_password user_data
    user = User[:email => user_data[:email]]
    return false unless user
                    and user.verify_password(user_data[:password])
    user
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

