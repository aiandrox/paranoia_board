class User < ApplicationRecord
  has_many :comments, dependent: :destroy

  validates :first_name, presence: true
  validates :last_name, presence: :true
end
