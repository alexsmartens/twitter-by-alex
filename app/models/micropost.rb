class Micropost < ApplicationRecord
  belongs_to :user
  # This application adopts a design of one image per post, for more images
  # there is an option "has_many_attached", which allows multiple files to
  # be attached to a single Active Record object
  has_one_attached :image
  default_scope -> {order(created_at: :desc)}
  validates :user_id, presence: true
  validates :content, presence: true, length: {maximum: 140}
  # validates an image with active_storage_validations gem
  validates :image, content_type: {in: %w[image/jpeg image/gif image/png],
                                   message: "must be a valid image format"},
                    size: {less_than: 5.megabytes,
                           message: "should be less than 5MB"}
end
