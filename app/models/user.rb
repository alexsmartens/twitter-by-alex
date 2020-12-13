class User < ApplicationRecord
  attr_accessor :activation_token,  # used for account activation
                :remember_token,    # used for persistent sessions
                :reset_token        # used for password reset
  # dependent: :destroy, ensures that the related records in the corresponding
  # table (microposts in this case) are destroyed when a user is destroyed
  has_many :microposts, dependent: :destroy

  # 'class_name' is to be specified if the underlying model has a different name
  has_many :active_relationships, class_name: "Relationship",
                                  foreign_key: "follower_id",
                                  dependent: :destroy
  has_many :passive_relationships, class_name: "Relationship",
                                   foreign_key: "followed_id",
                                   dependent: :destroy
  # Notes:
  #   1) "has_many :following ..." is a proxy (or a mirror) of
  #      "has_many :active_relationships ..."
  #   2) "source: :followed" - allows to override the default reference source,
  #      which means we could use "following" instead of "followeds" (which
  #      would be a default). In other words, this change directs Rails to look
  #      for "followed_id"
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower

  # before_save: called every time an object is saved. So for NEW and EXISTING
  # objects. (create and update action)
  before_save :downcase_email
  # before_create: called only before creation. So only for NEW objects (create
  # action). Also, before_create is run after before_save on new instance creation
  before_create :create_activation_digest
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
  # - (optional*) password_confirmation must much password if password_confirmation
  # is not nil (password_confirmation value is an empty string if this field
  # is present on the form, hence it should match password in this case).
  # * On the contrary,  if confirmation validation is not needed, simply leave out
  # the value for password_confirmation (i.e. don't provide a form field for it).
  # When this attribute has a nil value, the validation will not be triggered. For
  # more info: https://api.rubyonrails.org/classes/ActiveModel/SecurePassword/ClassMethods.html
  has_secure_password
  validates :password, presence: true, length: {minimum: 6}, allow_nil: true
  validate :change_requested?

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
  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")  # same as self.send(..), where self refers to the instance
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  # [Instance method] Forget a user
  def forget
    update_attribute(:remember_digest, nil)
  end

  # [Instance method] Changes the user's activation status to 'active'
  def activate
    # Update multiple attributes at the same time without validation
    update_columns(
      activated: true,
      activated_at: Time.zone.now
    )
  end

  # [Instance method] Sends out a user activation email
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  # Sets the password reset attributes
  def create_reset_digest
    self.reset_token = User.new_token
    update_columns(
      reset_digest:  User.digest(reset_token),
      reset_sent_at: Time.zone.now
    )
  end

  # Sends password reset email
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  # Returns tru if a password reset token has expired
  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

  # Voids password reset attributes
  def void_password_reset
    update_columns(
      reset_digest:  nil,
      reset_sent_at: nil
    )
  end

  def feed
    Micropost.where(user_id: following_ids << id)
  end

  # Follows a user
  def follow(other_user)
    following << other_user
  end

  # Unfollows a user
  def unfollow(other_user)
    following.delete(other_user)
  end

  # Returns true if the current user is following the other user
  def following?(other_user)
    following.include?(other_user)
  end

  private

    def downcase_email
      email.downcase!
    end

    # Creates and assigns the activation token and digest
    def create_activation_digest
      self.activation_token = User.new_token
      self.activation_digest = User.digest(activation_token)
    end

    def change_requested?
      # changed_attribute_names_to_save - returns a hash of the attributes that
      # will change when the record is next saved https://api.rubyonrails.org/classes/ActiveRecord/AttributeMethods/Dirty.html
      if changed_attribute_names_to_save.length > 0
        return true
      else
        errors.add(:base, "No field has been changed")
        return false
      end
    end
end
