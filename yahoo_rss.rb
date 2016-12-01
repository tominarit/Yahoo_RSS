require 'open-uri'
require 'Nokogiri'
require 'mysql2'
require 'csv'
require './const'

class YahooRSSGetter
  attr_accessor :original_url, :target_urls

  TARGET_URL = "http://news.yahoo.co.jp/pickup/"

  def initialize (original_url)
    @original_url = original_url
  end

  def get_html
    @html = open(@original_url) do |f|
      @charset = f.charset
      f.read
    end
  end

  def get_urls
    @target_urls = []
    doc = Nokogiri::HTML.parse(@html, nil, @charset)

    doc.css('a').each do |element|
      @target_urls << element[:href] if element[:href].include?(TARGET_URL)
    end
  end

  def import_data
    #@client = Mysql2::Client.new(:host => "localhost", :username => "root", :password => "shrewsbury12", :database => "Yahoo_RSS")
    @client = Mysql2::Client.new(:host => HOST, :username => USERNAME, :password => PASS, :database => DB)
    target_urls.each do |url|
      xml = Nokogiri::XML(open(url).read)
      item_nodes = xml.xpath('//channel/item')
      item_nodes.each do |item|
        @title   = item.xpath('title').text
        @link    = item.xpath('link').text
        @pubDate = item.xpath('pubDate').text
        @guid    = item.xpath('guid').text

        insert_data
      end
    end
  end

  def export_data
    if File.exist?("result.csv")
      retrieve_data_with_dates
    else
      retrieve_data_without_dates
    end
  end

  private
  def insert_data
    @client.query("insert into Yahoo_RSS (title, link, pubDate, guid) values ('#{@title}', '#{@link}', '#{@pubDate}', '#{@guid}')")
  end

  def retrieve_data_with_dates
    @client.query("select * into outfile '/Users/tominarit/github_test/Yahoo_RSS/result#{Date.today}.csv' fields terminated by ',' from Yahoo_RSS")
  end

  def retrieve_data_without_dates
    @client.query("select * into outfile '/Users/tominarit/github_test/Yahoo_RSS/result.csv' fields terminated by ',' from Yahoo_RSS")
  end

end
