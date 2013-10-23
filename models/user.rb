class User < ActiveRecord::Base
  validates :username, :email, presence: true
  has_many :surveys

  include BCrypt

  def password
    @password ||= Password.new(password_hash)
  end

  def password=(new_password)
    @password = Password.create(new_password)
    self.password_hash = @password
  end

  def self.authenticate(params)
    user = User.find_by username: params[:username]
    if user and user.password == params[:password]
      return user
    else
      return nil
    end
  end


end
