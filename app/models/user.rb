class User < ApplicationRecord
  attr_accessor :remember_token  # add object attribute
  before_save { self.email = email.downcase}
  validates :name, presence: true, length: {maximum: 50}
  VALID_EMAIL_REGEX =  /\A[\w\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
            format: { with: VALID_EMAIL_REGEX },
            uniqueness: true
  # Add methods to set and authenticate against a BCrypt password. This
  # mechanism requires you to have a XXX_digest attribute. Where XXX is the
  # attribute name of your desired password. The following validations are
  # added automatically:
  # - Password must be present on creation (but allows blank passwords " ")
  # - Password length should be less than or equal to 72 bytes
  # - (optional) Confirmation of password (using a XXX_confirmation attribute)
  # Also, automatically adds authenticate method to the User objects
  has_secure_password
  validates :password, presence: true, confirmation: true, length: {minimum: 6},
    allow_nil: true

  # [Class method] Returns the hash digest of the given string
  def User.digest(string)  # alternative: "self.digest(string)"
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # [Class method] Returns a random token
  def User.new_token  # alternative: "self.new_token"
    SecureRandom.urlsafe_base64
  end

  # [Instance method] Remembers a user in the database for use in persistent session
  def remember
    self.remember_token = User.new_token  # cannot use self.new_token here coz
      # 'self' would refer to the instance instead of referring to the class
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  # [Instance method] Returns true if the given token matches the digest
  def authenticated?(remember_token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  # [Instance method] Forget a user
  def forget
    update_attribute(:remember_digest, nil)
  end

end
