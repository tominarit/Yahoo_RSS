require '..yahoo_rss'
#おまじない
RSpec.describe YahooRSSGetter do
  #contextも使える
  describe '全メソッドのテスト' do

    let(:yahoo_rss) {YahooRSSGetter.new("http://headlines.yahoo.co.jp/rss/list")}

    it '初期化：WebAnalyzer.new("...")でWebAnalyzer.nameに...が入っている' do
      expect(yahoo_rss.original_url).to eq "http://headlines.yahoo.co.jp/rss/list"
    end

    it '初期化URLをパースして対象URLを取ってくる' do
skip
      # yahoorss.get_html
      # expect(yahoorss.instance_variable_get(:@html)).to eq @html
    end

    it 'getURLでURLが９つ格納される' do
      yahoo_rss.get_html
      expect(yahoo_rss.get_urls.size + 1).to eq 9
    end
  end
end
