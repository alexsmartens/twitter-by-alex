class Reaction < ApplicationRecord
  VALID_REFERENCE_TYPES = %w[Micropost]

  belongs_to :reference, polymorphic: true
  belongs_to :user

  before_validation :remove_current_reaction_of_user_on_reference
  validates_presence_of :reference_id, :reference_type, :user_id, :reaction_type
  validates :reference_type, inclusion: { in: VALID_REFERENCE_TYPES }

  enum reaction_type: {
    love: "love",
    dislike: "dislike",
  }

  scope :loves, -> { where(reaction_type: :love) }
  scope :dislikes, -> { where(reaction_type: :dislike) }

  def remove_current_reaction_of_user_on_reference
    # Make sure the new reaction replaces the most recent one
    Reaction.where(reference_id: reference_id,
                   reference_type: reference_type,
                   user_id: user_id,
    ).first&.destroy
  end
end
