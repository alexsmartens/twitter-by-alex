class Micropost < ApplicationRecord
  belongs_to :user
  # This application adopts a design of one image per post, for more images
  # there is an option "has_many_attached", which allows multiple files to
  # be attached to a single Active Record object
  has_one_attached :image
  has_many :loves, -> { loves }, as: :reference, class_name: :Reaction, foreign_key: :reference_id, dependent: :destroy
  has_many :dislikes, -> { dislikes }, as: :reference, class_name: :Reaction, foreign_key: :reference_id

  validates :user_id, presence: true
  validates :content, presence: true, length: {maximum: 140}
  # validates an image with active_storage_validations gem
  validates :image, content_type: {in: %w[image/jpeg image/gif image/png],
                                   message: "must be a valid image format"},
                    size: {less_than: 5.megabytes,
                           message: "should be less than 5MB"}

  default_scope -> { order(created_at: :desc) }

  scope :feed, -> (user_id:) {
    following_ids_sql = <<-HEREDOC
      SELECT followed_id
      FROM relationships
        WHERE follower_id = :user_id
    HEREDOC

    where("user_id IN (#{following_ids_sql})
           OR user_id = :user_id", user_id: user_id)
  }

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
    # Limit both width and height of the image to the specified size
    image.variant(resize_to_limit: [500, 500])
  end

  def love_counter
    loves.count
  end

  def dislike_counter
    dislikes.count
  end
end
