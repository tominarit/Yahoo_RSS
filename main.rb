require './yahoo_rss'

yahoo_rss = YahooRSSGetter.new("http://headlines.yahoo.co.jp/rss/list")
yahoo_rss.get_html
yahoo_rss.get_urls
yahoo_rss.import_data
yahoo_rss.export_data
