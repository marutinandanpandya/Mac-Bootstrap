require 'net/http'
require 'nokogiri'
require 'date'

URL = 'https://www.moneycontrol.com/stocks/marketinfo/dividends_declared/index.php'

# This script parse and download image files from html documents
def get_html(url)
  uri = URI(url)
  response = Net::HTTP.start(uri.host, uri.port,
                             :use_ssl => uri.scheme == 'https') do |http|
    resp = http.get(uri.path)
    case resp
    when Net::HTTPSuccess then
      resp.body
    when Net::HTTPRedirection then
      get_html(resp['location']) 
    else
      resp.value
    end
  end
end

def fetch_price(url)
  html = get_html("http://www.moneycontrol.com/#{url}")
  html_doc = Nokogiri::HTML(html)
  bse_price = html_doc.css('#Bse_Prc_tick').text.to_f
  nse_price = html_doc.css('#Nse_Prc_tick').text.to_f
  face_value = html_doc.css('#mktdet_1').css('.PA7')[10].css('.FR').text.to_f
  return { bse_price: bse_price, nse_price: nse_price, face_value: face_value }
end


stocks = []
html = get_html(URL)
html_doc = Nokogiri::HTML(html)
      puts "Name, RecordDate,BsePrice,NsePrice, DividentPerShare, DividendPayoutRation"
html_doc.css('table').css('.tbldata14')[0].css('tr').each_with_index do |stock_block, index|
    next if index < 2
    stock_info = stock_block.css('td')
    name =  stock_info[0].css('b').text
  begin
    divident_percent = stock_info[2].children[0].text.to_f
    record_date = stock_info[5].children[0].text
    next if Date.today >= Date.parse(record_date)
    stock_url = stock_info[0].css('a').first['href']
    info = fetch_price(stock_url)
    begin
      d_p_s = info[:face_value]*divident_percent/100.00
      divident_ratio = info[:bse_price] ? ((info[:face_value]*divident_percent)/info[:bse_price]).round(2) : ((info[:face_value]*divident_percent)/info[:nse_price]).round
      puts "#{name},#{record_date},#{info[:bse_price]},#{info[:nse_price]},#{d_p_s}, #{divident_ratio}"
    rescue => e
      puts "#{name},#{record_date},#{info[:bse_price]},#{info[:nse_price]},0, 0"
    end
  rescue => e
    puts "--- parsing failed for :#{name} company"
  end
end
