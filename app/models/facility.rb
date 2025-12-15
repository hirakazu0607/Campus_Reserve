class Facility < ApplicationRecord
  # アソシエーション
  has_many :reservations, dependent: :destroy

  # バリデーション
  validates :name, presence: true, length: { maximum: 100 }, uniqueness: true
  validates :description, length: { maximum: 500 }
  validates :capacity, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :location, presence: true, length: { maximum: 200 }
end
