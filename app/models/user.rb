class User < ApplicationRecord
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
    # - Password must be present on creation
    # - Password length should be less than or equal to 72 bytes
    # - (optional) Confirmation of password (using a XXX_confirmation attribute)
    has_secure_password
end
