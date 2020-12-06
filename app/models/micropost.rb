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

  # Limits both width and height of the image to the specified size
  def display_image
    # Dependencies:
    #   (1) ImageMagic OS package, it comes preinstalled on Heroku
    #   (2) image_processing gem
    #   (3) mini_magic gem
    #
    # Note 'variant' action:
    # variant  resizing happens on demand when the method is first called and
    # is cached for subsequent uses afterwards. For larger sites, it's better to
    # deffer such processing to a background process.
    #
    image.variant(resize_to_limit: [500, 500])
  end
end
