class Comment < ApplicationRecord
  before_save :add_data
  belongs_to :user
  validates :body, presence: true
  validates :body, length: { maximum: 200 }
  validate :check_body

  scope :desc, -> { order(created_at: :desc) }

  def sentiment
    if score < -0.4
      :negative
    elsif score < 0.1
      :neutral
    else
      :positive
    end
  end

  private

  def check_body
    return if body.empty?

    case sentiment
    when :neutral
      errors.add(:body, '幸福な内容を投稿してください。')
    when :negative
      errors.add(:body, '幸福な内容を投稿してください。ZapZapZap')
    end
  end

  def add_data
    self.sentiment_score = score
    self.sender_name = user.full_name
  end

  def score
    GoogleSentimentAnalysisServise.new(body).sentiment_score
  end
end
