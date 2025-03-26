class Bulletin < ApplicationRecord
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
