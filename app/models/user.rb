class User < ApplicationRecord
  attr_accessor :uuid
  before_create :set_data
  has_many :comments, dependent: :destroy

  validates :first_name, presence: true, on: :update
  validates :first_name, format: { with: /[a-zA-Z]+/, message: "半角英字のみ使えます" }, on: :update
  validates :first_name, length: { maximum: 10 }

  def authenticated?(uuid)
    BCrypt::Password.new(user_digest) == uuid
  end

  def full_name
    "#{first_name}#{last_name}-#{clone_number}"
  end

  def zap
    update(clone_number: clone_number + 1)
  end

  private

  def set_data
    self.uuid = User.new_uuid
    self.first_name = Gimei.first.romaji
    self.last_name = User.new_last_name
    self.user_digest =  User.digest(uuid)
  end

  class << self
    def new_uuid
      SecureRandom.urlsafe_base64
    end

    def new_last_name
      sector = (0..2).map{ ('A'..'Z').to_a[rand(26)] }.join
      "-#{clearance}-#{sector}"
    end

    def clearance
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
