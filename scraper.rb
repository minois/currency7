require 'scraperwiki'
require 'mechanize'
require 'pry'

date = Time.now.strftime('%Y-%m-%d')
agent = Mechanize.new

BASE_URL = "https://currency7.com/ja/%s-to-JPY-exchange-rate-converter"
currencies = [
  "USD",
  "EUR",
  "GBP",
  "AUD",
  "NZD"
].freeze

rates = []
currencies.each do |currency|
  url = BASE_URL % currency
  page = agent.get(url)
  rates << {
    'date' => date,
    'currency' => currency,
    'rate' => page.at('ul.quick-rate-a li').text.match(/\d+\s+#{currency}\s+=\s+([0-9.]+)\s+JPY/)[1].to_f.round(2)
  }
end

ScraperWiki.save_sqlite(["currency", "date"], rates, 'currency_rates')
