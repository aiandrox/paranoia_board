class Comment < ApplicationRecord
  before_save :add_data
  belongs_to :user
  validate :user_valid
  validates :body, presence: true
  validates :body, length: { maximum: 200 }
  validate :body_sentiment

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

  def user_valid
    if user.clone_number > 6
      errors.add(:user_id, 'は規制されています')
    end
  end

  def body_sentiment
    return if errors.any?

    case sentiment
    when :neutral
      errors.add(:body, 'には幸福な内容を入力してください')
    when :negative
      errors.add(:body, 'が反逆的です。ZapZapZap')
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
