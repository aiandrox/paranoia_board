class User < ApplicationRecord
  attr_accessor :uuid, :clearance
  before_create :set_data
  has_many :comments, dependent: :destroy

  validates :first_name, presence: true, on: :update
  validates :first_name, format: { with: /\A[a-zA-Z]+\z/, message: "は半角英字にしてください" }, on: :update
  validates :first_name, length: { maximum: 10 }

  scope :alive, -> { where(&:alive?) }

  def zap!
    # selfはcommentオブジェクト（invalid）を持っているので、userという別オブジェクトとして更新する
    user = User.find(id)
    user.update!(clone_number: clone_number + 1)
    reload
  end

  def authenticated?(uuid)
    BCrypt::Password.new(user_digest) == uuid
  end

  def alive?
    clone_number <= 6
  end

  def full_name
    alive? ? "#{first_name}-#{clearance}-#{sector}-#{clone_number}" : '[規制されました]'
  end

  private

  def set_data
    self.uuid = User.new_uuid
    self.first_name = Gimei.first.romaji
    self.sector = (0..2).map{ ('A'..'Z').to_a[rand(26)] }.join
    self.clearance = User.new_clearance
    self.user_digest =  User.digest(uuid)
  end

  class << self
    def new_uuid
      SecureRandom.urlsafe_base64
    end

    def new_clearance
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
