class User < ApplicationRecord
  attr_accessor :uuid
  has_many :comments, dependent: :destroy

  validates :first_name, presence: true
  validates :first_name, format: { with: /[a-zA-Z]+/, message: "半角英字のみ使えます" }

  def authenticated?(uuid)
    BCrypt::Password.new(user_digest) == uuid
  end

  def full_name
    "#{first_name}#{last_name}-#{clone_number}"
  end

  private

  after_initialize do |user|
    user.uuid = User.new_uuid
    user.first_name = Faker::Name.first_name
    user.last_name = User.new_last_name
    user.user_digest =  User.digest(uuid)
  end

  class << self
    def new_uuid
      SecureRandom.urlsafe_base64
    end

    def new_last_name
      residence = (0..2).map{ ('A'..'Z').to_a[rand(26)] }.join
      "-#{class_color}-#{residence}"
    end

    def class_color
      colors = [['R', 2500], ['O', 500], ['Y', 100], ['G', 50], ['B', 30], ['I', 10], ['V', 1 ]] # [文字列, 重み]
      array = []
      colors.each do |item|
        array.push(Array.new(item[1], item[0]))
      end
      array.flatten.sample
    end

    def digest(string)
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
      BCrypt::Password.create(string, cost: cost)
    end
  end
end
