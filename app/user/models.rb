require 'sequel'
require 'securerandom'
require 'digest'

class User < Sequel::Model
  plugin :validation_helpers
  one_to_many :user_roles
  one_to_many :user_sessions

  attr_accessor :password

  def before_validation
    if !self.password or self.password.empty? and !self.exists?
      self.errors.add(:password, "cannot be empty")
    elsif !self.exists?
      self.password_salt = SecureRandom.urlsafe_base64(24)
      self.password_hash = Digest::SHA512.hexdigest(self.password_salt + self.password)
    end
    super
  end

  def validate
    super
    validates_presence [:displayname, :email]
    validates_min_length 2, :displayname
    validates_format %r{^.+?@.+?\..+?$}, :email
  end

  def verify_password password
    self.password_hash == Digest::SHA512.hexdigest(self.password_salt + password)
  end

  def to_json arg=nil
    data = {
      displayname: self.displayname,
      id: self.pk,
      roles: self.user_roles,
    }
    data[:email] = self.email if arg == :all
    data.to_json arg
  end

  def has_role role
    self.user_roles.any?{|r| r.role == role}
  end

  def self.login_with_password user_data
    user = User[:email => user_data["email"]]
    return false unless user and
                        user.verify_password(user_data["password"])
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

