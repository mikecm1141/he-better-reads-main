class User < ApplicationRecord
  has_many :reviews, dependent: :destroy

  validates :first_name, :last_name, presence: true
end
