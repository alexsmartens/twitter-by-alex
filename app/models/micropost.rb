class Micropost < ApplicationRecord
  belongs_to :user
  # This application adopts a design of one image per post, for more images
  # there is an option "has_many_attached", which allows multiple files to
  # be attached to a single Active Record object
  has_one_attached :image
  default_scope -> {order(created_at: :desc)}
  validates :user_id, presence: true
  validates :content, presence: true, length: {maximum: 140}
end
