require 'faraday'
require 'nokogiri'
require 'date'

# INTERESTING_TRAIN_IDS = [
#   '1_701Б_1567787820_1567800240',
#   '1_711Б_1567790160_1567803120',
# ]

#test
INTERESTING_TRAIN_IDS = [
  '1_663Б_1567784160_1567801320',
]
from = 'Минск-Пассажирский'
to = 'Брест'
# date = (Date.today + 1).to_s
date = '2019-09-06'
sleep_sec = 180
rw_url = "https://rasp.rw.by/ru/route/?from=#{from}&to=#{to}&date=#{date}"
allert_message = 'ALLERT!!!\n Train FOUNDED!!'

loop do
  page = fetch_data_from_url

  INTERESTING_TRAIN_IDS.each do |train_id|
    if page.css("tr\##{train_id} li.train_price span").empty?
      puts 'TrainID #{train_id} - nothing found'
      next
    else
      success_notify
    end
  end
  sleep sleep_sec
end

def mac_os?
  Gem::Platform.local.os == 'darwin'
end

def success_notify
    puts allert_message
    puts `osascript -e 'display notification "#{allert_message}" with title "Greetings"'` if mac_os?
end

def fetch_data_from_url
  puts "Fetching data from #{rw_url}\n"
  response = Faraday.get rw_url
  Nokogiri::HTML(response.body)
end
