class User < ActiveRecord::Base
  validates :username, :email, presence: true
  validates :username, :email, uniqueness: true
  has_many :surveys

  include BCrypt

  def password
    @password ||= Password.new(password_hash)
  end

  def password=(new_password)
    @password = Password.create(new_password)
    self.password_hash = @password
  end

  def self.authenticate(username, check_password)
    user = User.find_by username: username
    if user and user.password == check_password
      return user
    else
      return nil
    end
  end


end
