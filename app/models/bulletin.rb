class Bulletin < ApplicationRecord
  include AASM

  aasm column: "state" do
    state :draft, initial: true
    state :under_moderation
    state :rejected
    state :published
    state :archived

    event :to_moderate do
      transitions from: :draft, to: :under_moderation
    end

    event :reject do
      transitions from: :under_moderation, to: :rejected
    end

    event :publish do
      transitions from: :under_moderation, to: :published
    end

    event :archive do
      transitions from: [ :draft, :under_moderation, :rejected, :published ], to: :archived
    end
  end

  def self.ransackable_attributes(auth_object = nil)
    [ "category_id", "title" ]
  end

  belongs_to :user
  belongs_to :category

  has_one_attached :image

  validates :title, presence: true
  validates :title, length: { minimum: 5, maximum: 50 }

  validates :description, presence: true
  validates :description, length: { minimum: 5, maximum: 1000 }

  validates :image,
            attached: true,
            content_type: %i[png jpg jpeg],
            size: { less_than: 5.megabytes }
end
