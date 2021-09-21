class Book < ApplicationRecord
  belongs_to :author

  has_many :reviews, dependent: :destroy

  validates :title, :description, presence: true
end
