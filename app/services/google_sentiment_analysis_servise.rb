require "google/cloud/language"

class GoogleSentimentAnalysisServise
  attr_reader :text_content

  def initialize(text_content)
    @text_content = text_content
  end

  def sentiment_score
    response.document_sentiment.score
  end

  # 基本的に使わない想定
  # sentences.each do |sentence|
  #   "#{sentence.text.content}<#{sentence.sentiment.score}>"
  # end
  def sentences
    response.sentences
  end

  private

  def language
    @language ||= Google::Cloud::Language.language_service(credentials: JSON.parse(ENV.fetch('GOOGLE_API_CREDS')))
  end

  def response
    document = { content: text_content, type: :PLAIN_TEXT }
    @response ||= language.analyze_sentiment(document: document)
  end
end
