class ToppagesController < ApplicationController
  before_action :login_required, only: [:timeline, :tweet]
  include Common
  require 'twitter'
  require 'mecab'
  require 'open-uri'
  require 'net/http'
  require 'json'

  # Amazon::Ecs.configure do |options|
  #   options[:AWS_access_key_id] = ENV['AWS_access_key']
  #   options[:AWS_secret_key] = ENV['AWS_secret_key']
  #   options[:associate_tag] = ENV['AWS_associate_tag']
  # end
  #
  # Amazon::Ecs::debug = true
  #

  def tweet
    if(params[:text] == '')
      flash[:danger] = '新規Tweetが空です'
      render './layouts/_flash_messages.html.erb'
    else
      client = client_new
      client.update(params[:text])
      redirect_to home_path
    end
  end

  def timeline
    client = client_new
    @user = client.user
    @tweets = Kaminari.paginate_array(client.home_timeline(include_entities: true)).page(params[:page]).per(5)

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

    #cookieがセッションオーバーしないように、取り出す個数を制限
    nouns_limit = []
    for i in 0..9 do
      nouns_limit << nouns[i]
    end

    @nouns = nouns_limit.map { |noun| noun[:noun] }

    session[:nouns] = @nouns

    # 10words
    @str = ''
    @nouns[0..10].each do |noun|
      noun = noun.gsub(/(@.*|http.*)/,"")
      if @str == ''
        @str = @str + noun
      else
        @str = @str + '+' + noun
       end
    end

    #8words
    @str_8 = ''
    @nouns[0..8].each do |noun|
      noun = noun.gsub(/(@.*|http.*)/,"")
      if @str_8 == ''
        @str_8 = @str_8 + noun
      else
        @str_8 = @str_8 + '+' + noun
       end
    end

    #5words
    @str_5 = ''
    @nouns[0..5].each do |noun|
      noun = noun.gsub(/(@.*|http.*)/,"")
      if @str_5 == ''
        @str_5 = @str_5 + noun
      else
        @str_5 = @str_5 + '+' + noun
       end
    end
    
    session[:str_10] = @str
    session[:str_8] = @str_8
    session[:str_5] = @str_5
    
    p "***session[:str_10]の中身***"
    p session[:str_10]
    p "------------------"
    p "***session[:str_8]の中身***"
    p session[:str_8]
    p "------------------"
    p "***session[:str_5]の中身***"
    p session[:str_5]
    
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
  
  #10words
  def analyze_10
   
    base_url = 'https://www.googleapis.com/books/v1/volumes?q='
    keyword_10 = session[:str_10]
    url = URI.parse(URI.encode(base_url + keyword_10))
    p "URI結果" + url.to_s
    result = Net::HTTP.get_response(url)
    p result.to_s
    json = JSON.parse(result.body)

    unless json['items'] == nil

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

        #リンク先
        if item['volumeInfo'].has_key?('infoLink')
          info_name = item['volumeInfo']['infoLink']
        else
          info_name = nil
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
            info: info_name,
            authors: authors_name,
            thumbnail: thumbnail_name,
            description: description_name
        }

        p "***dataの情報***"
        p data
        @datas << data
      end

    else
      render 'analyze_10'
    end

  end
  
  #8words
  def analyze_8
    
    base_url = 'https://www.googleapis.com/books/v1/volumes?q='
    keyword_8 = session[:str_10]
    url = URI.parse(URI.encode(base_url + keyword_8))
    p "URI結果" + url.to_s
    result = Net::HTTP.get_response(url)
    p result.to_s
    json = JSON.parse(result.body)
    
    unless json['items'] == nil
    
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
        
        #リンク先
        if item['volumeInfo'].has_key?('infoLink')
          info_name = item['volumeInfo']['infoLink']
        else
          info_name = nil
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
            info: info_name,
            authors: authors_name,
            thumbnail: thumbnail_name,
            description: description_name
        }
        p "***dataの情報***"
        p data
        @datas << data
      end
    
    else
      render 'analyze_8'
    end
  end
  
  
  #5words
  def analyze_5
    
    base_url = 'https://www.googleapis.com/books/v1/volumes?q='
    keyword_5 = session[:str_5]
    url = URI.parse(URI.encode(base_url + keyword_5))
    p "URI結果" + url.to_s
    result = Net::HTTP.get_response(url)
    p result.to_s
    json = JSON.parse(result.body)
    
    unless json['items'] == nil
    
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
        
        #リンク先
        if item['volumeInfo'].has_key?('infoLink')
          info_name = item['volumeInfo']['infoLink']
        else
          info_name = nil
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
            info: info_name,
            authors: authors_name,
            thumbnail: thumbnail_name,
            description: description_name
        }
        p "***dataの情報***"
        p data
        @datas << data
      end
    
    else
      render 'analyze_5'
    end
  end
end
