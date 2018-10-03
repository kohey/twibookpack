class ToppagesController < ApplicationController
  before_action :login_required, only: [:timeline, :tweet]
  include Common
  require 'twitter'
  require 'mecab'
  require 'open-uri'
  require 'net/http'
  require 'json'
  

  def tweet
    client = client_new
    client.update(params[:text])
    redirect_to home_path
  end

  def timeline
    client = client_new
    @user = client.user
    @tweets = client.home_timeline(include_entities: true)

    

    p @user.tweets_count
    p client.home_timeline.count
    
    # 以下竹原追記↓
    # こっちはフォローも含めたタイムラインを出力
    # @tweets.each do |tweet|
    #   p tweet.text
    # end
    
    # こっちは特定ユーザのユーザーのid元にtimeline取得、timelineidごとにステータスを取得しテキスト引っ張り出す
    @user_timeline = client.user_timeline(@user.id)
    
    parser = MeCab::NounParser.new

    @user_timeline.each do |timeline|
      p client.status(timeline.id).text
      parser << client.status(timeline.id).text
    end
    #parserにはtweetが配列で入る
    p "***parserの中身***"
    p parser
  
    nouns = parser.parse.nouns
    p "***nounsの中身***"
    p nouns
    @nouns = nouns.map { |noun| noun[:noun] }
    
    
    @str = ''
    @nouns[0..10].each do |noun|
      noun = noun.gsub(/(@.*|http.*)/,"")
      if @str == ''
        @str = @str + noun
      else
        @str = @str + '+' + noun
       end
    end
    
    session[:str] = @str
    p "***@strの中身***"
    p @str
  end
  
  def client_new
    Twitter::REST::Client.new do |config|
      p "***client_newの中身***"
      p config.consumer_key = ENV["TWITTER_CONSUMER_KEY"]
      p config.consumer_secret = ENV["TWITTER_CONSUMER_SECRET"]
      p config.access_token = session[:oauth_token]
      p config.access_token_secret = session[:oauth_token_secret]
    end
  end
  
  def analyze
    
    base_url = 'https://www.googleapis.com/books/v1/volumes?q='
    keyword = session[:str]
    url = URI.parse(URI.encode(base_url + keyword))
    p "URI結果" + url.to_s
    result = Net::HTTP.get_response(url)
    p result.to_s
    json = JSON.parse(result.body)
    
    @datas = []
    json['items'].each do |item|
      
      #著者
      if item['volumeInfo'].has_key?('authors')
        authors_name = item['volumeInfo']['authors'][0]
      elsif item['volumeInfo'].has_key?('publisher')
        authors_name = item['volumeInfo']['publisher']
      else
        authors_name = '不明'
      end
      
      #タイトル
      if item['volumeInfo'].has_key?('title')
        title_name = item['volumeInfo']['title']
      else
        titile_name = '不明'
      end
      
      #識別番号
      if item['volumeInfo'].has_key?('industryIdentifiers')
        code_name = item['volumeInfo']['industryIdentifiers'][0]['identifier']
      else
        code_name = '不明'
      end
      
      #サムネイル
      if item['volumeInfo'].has_key?('imageLinks')
        thumbnail_name = item['volumeInfo']['imageLinks']['thumbnail']
      else
        thumbnail_name = "NO IMAGE"
      end
      
      #説明
      if item['volumeInfo'].has_key?('description')
        description_name = item['volumeInfo']['description']
      else
        description_name = '説明はありません'
      end
      data = {  
          code: code_name,
          title: title_name,
          authors: authors_name,
          thumbnail: thumbnail_name,
          description: description_name
      }
      p "***dataの情報***"
      p data
      @datas << data
    end
  end
end
