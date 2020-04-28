class User < ApplicationRecord
  validates :user_name, :session_token, :password_digest, presence: true
  validates :user_name, :session_token, uniqueness: true
  validates :password, length: { minimum: 6, allow_nil: true }

  after_intialize :ensure_session_token
  attr_reader :password

  has_many :cats,
    foreign_key: :user_id,
    class_name: :Cat

  def self.generate_session_token
    SecureRandom.urlsafe_base64
  end 

  def self.find_by_credentials(user_name, password)
    user = User.find_by(user_name: user_name)

    if user && user.is_password?(password)
      user
    else
      nil
    end
  end

  def ensure_session_token
    self.session_token ||= User.generate_session_token
  end

  def reset_session_token!
    self.update!(session_token: User.generate_session_token)
    # session_token = SecureRandom.urlsafe_base64
    self.session_token
  end

  # Used during user creation to hash password
  def password=(pass)
    @password = pass # When do we use this instance variable?
    self.password_digest = BCrypt::Password.create(@password)
  end 
  
  # Used during login to check if attempted password is correct
  def is_password?(pass)
    bcrypt_digest = BCrypt::Password.new(self.password_digest)
    bcrypt_digest.is_password(pass)
    # BCrypt::Password.new(pass)
  end 
    
end