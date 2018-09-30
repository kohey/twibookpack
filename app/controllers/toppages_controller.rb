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
      # str = str + client.status(timeline.id).text
      parser << client.status(timeline.id).text
    end
    p parser
    # ここまで↑
    nouns = parser.parse.nouns
    @nouns = nouns.map { |noun| noun[:noun] }
    p @nouns
    
    @str = ''
    @nouns.each do |noun|
      if @str == ''
        @str = @str + noun
      else
        @str = @str + '+' + noun
       end
    end
    
    session[:str] = @str
    p "***sessionの値(タイムライン)***"
    p session[:str]
    # binding.prys
    
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
    
    counter = 0
    @datas = []
    json['items'].each do |item|
      counter += 1
      
      if item['volumeInfo'].has_key?('authors')
        authors_name = item['volumeInfo']['authors'][0]
      elsif item['volumeInfo'].has_key?('publisher')
        authors_name = item['volumeInfo']['publisher']
      else
        authors_name = '不明'
      end
      
      # binding.pry if counter == json['items'].length - 1
      data = {  
          code: item['volumeInfo']['industryIdentifiers'][1]['identifier'] || '不明',
          title: item['volumeInfo']['title'] || '不明',
          authors: authors_name,
          thumbnail: item['volumeInfo']['imageLinks']['thumbnail'] || 'NO IMAGE',
          description: item['volumeInfo']['description'] || '説明はありません'
      }
      p "***dataの情報***"
      p data
      @datas << data
    end
  end
end
