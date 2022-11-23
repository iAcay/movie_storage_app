class Director < ApplicationRecord
  has_many :movies, dependent: :nullify
  validates :name, presence: true
end
