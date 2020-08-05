class Comment < ApplicationRecord
  before_validation :filter_body
  belongs_to :user
  validates :body, presence: true

  private

  def filter_body
    response
    debugger
  end

  def response
    cotoha_client.sentiment(sentence: body)
  end

  def cotoha_client
    client_id = Rails.application.credentials.cotoha[:client_id]
    client_secret = Rails.application.credentials.cotoha[:client_secret]
    client = Cotoha::Client.new(client_id: client_id, client_secret: client_secret)
    client.create_access_token
    client
  end
end
