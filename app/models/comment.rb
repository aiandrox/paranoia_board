class Comment < ApplicationRecord
  before_save :filter_body
  belongs_to :user
  validates :body, presence: true
  validate :check_body

  private

  def check_body
    case cotoha_rerult['sentiment']
    when 'Neutral'
      errors.add(:body, '幸福な内容を投稿してください。')
    when 'Negative'
      errors.add(:body, '幸福な内容を投稿してください。ZapZapZap')
      self.user.clone_number += 1
      self.save!
    end
  end

  def filter_body
    self.sentiment_score = cotoha_result['score']
  end

  def cotoha_rerult
    @cotoha_result ||= begin
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
