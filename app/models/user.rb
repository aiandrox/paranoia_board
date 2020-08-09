class User < ApplicationRecord
  attr_accessor :uuid
  before_create :set_data
  has_many :comments, dependent: :destroy

  validates :first_name, presence: true, on: :update
  validates :first_name, format: { with: /\A[a-zA-Z]+\z/, message: "は半角英字で入力してください" }, on: :update
  validates :first_name, length: { maximum: 10 }

  scope :alive, -> { where(&:alive?) }

  def zap!
    # selfはcommentオブジェクト（invalid）を持っているので、userという別オブジェクトとして更新する
    user = User.find(id)
    user.update!(clone_number: clone_number + 1)
    reload
  end

  def create_citizen
    # binding.pry
    check_clone_number_valid
    self.sector = User.new_sector
    self.clone_number = 1
    errors.any? ? false : save
  end

  def authenticated?(uuid)
    BCrypt::Password.new(user_digest) == uuid
  end

  def alive?
    clone_number <= 6
  end

  def full_name
    alive? ? "#{first_name}-#{clearance}-#{sector}-#{clone_number}" : '<規制されました>'
  end

  def clearance
    @clearance ||= begin
      count = comments.count
      if count > 150
        'I'
      elsif count > 100
        'B'
      elsif count > 50
        'G'
      elsif count > 30
        'Y'
      elsif count > 10
        'O'
      else
        'R'
      end
    end
  end

  private

  def check_clone_number_valid
    errors.add(:clone_number, 'が残っています') if clone_number <= 6
  end

  def set_data
    self.uuid = User.new_uuid
    self.first_name = Gimei.first.romaji
    self.sector = User.new_sector
    self.user_digest =  User.digest(uuid)
  end

  class << self
    def new_uuid
      SecureRandom.urlsafe_base64
    end

    def new_sector
      (0..2).map{ ('A'..'Z').to_a[rand(26)] }.join
    end

    def digest(string)
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
      BCrypt::Password.create(string, cost: cost)
    end
  end
end
