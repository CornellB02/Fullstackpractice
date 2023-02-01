class User < ApplicationRecord

  has_secure_password

  # validates :users, :username, :email, :session_token, presence: true, uniqueness: true, 
  # validates :users, :username, length: { in: 3..30 }
  # validates :users, :email, length: { in: 3..255 }, format: { with: URI::MailTo::EMAIL_REGEXP }

validates :username, 
  uniqueness: true, 
  length: { in: 3..30 }, 
  format: { without: URI::MailTo::EMAIL_REGEXP, message:  "can't be an email" }
validates :email, 
  uniqueness: true, 
  length: { in: 3..255 }, 
  format: { with: URI::MailTo::EMAIL_REGEXP }
validates :session_token, presence: true, uniqueness: true
validates :password, length: { in: 6..255 }, allow_nil: true

before_validation :ensure_session_token

def self.find_by_credentials(credentials, password)
  user = User.find_by(username: credentials) || User.find_by(email: credentials)

  if user&.authenticate(password)
    return user
  else 
    nil
  end
end

def ensure_session_token
  self.session_token ||= generate_unique_session_token
end 

def reset_session_token!
  self.session_token = generate_unique_session_token
  self.save!
  session_token
end

private


def generate_unique_session_token
  while true 
     token = SecureRandom.urlsafe_base64
      return token unless User.exists?(session_token: token)
    end
end 



end
