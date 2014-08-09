require 'sequel'
require 'securerandom'
require 'digest'

class User < Sequel::Model
  plugin :validation_helpers
  many_to_many :roles, :join_table => :users_roles
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
      roles: self.roles,
    }
    data[:email] = self.email if arg == :all
    data.to_json arg
  end

  def has_role role
    role = [role.to_sym] unless role.is_a? Array
    self.user_roles.any?{|r| role.include? r.role.to_sym}
  end

  def self.login_with_password user_data
    user = User[:email => user_data["email"]]
    return false unless user and
                        user.verify_password(user_data["password"])
    user
  end
end


class Role < Sequel::Model
  many_to_many :users, :join_table => :users_roles
end


class UserSession < Sequel::Model
  many_to_one :user
  def before_create
    self.expiry_date = DateTime.now + Rational(6, 24)
    self.auth_key = SecureRandom.urlsafe_base64
    super
  end

end

