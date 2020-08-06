class Comment < ApplicationRecord
  before_save :add_data
  belongs_to :user
  validates :body, presence: true
  validate :check_body

  def sentiment
    cotoha_result['sentiment']
  end

  private

  def check_body
    return if body.empty?

    case sentiment
    when 'Neutral'
      errors.add(:body, '幸福な内容を投稿してください。')
    when 'Negative'
      errors.add(:body, '幸福な内容を投稿してください。ZapZapZap')
    end
  end

  def add_data
    self.sentiment_score = cotoha_result['score']
    self.sender_name = user.full_name
  end

  def cotoha_result
    @cotoha_result ||= begin
      { 'sentiment': 'Neutral' } if body.empty?

      response = cotoha_client.sentiment(sentence: body)
      response['result']
    end
  end

  def cotoha_client
    client_id = Rails.application.credentials.cotoha[:client_id]
    client_secret = Rails.application.credentials.cotoha[:client_secret]
    client = Cotoha::Client.new(client_id: client_id, client_secret: client_secret)
    client.create_access_token
    client
  end
end
