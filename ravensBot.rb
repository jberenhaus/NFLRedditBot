require 'redditkit'
require 'rss'
require 'date'
require 'net/http'
require 'json'

userPassFile = File.read('ravensBot.json')
userPassHash = JSON.parse(userPassFile)

client = RedditKit::Client.new userPassHash['username'], userPassHash['password']

videoFeedUrl = "http://www.baltimoreravens.com/cda-web/rss-module.htm?tagName=Videos"
newsFeedUrl = "http://www.baltimoreravens.com/cda-web/rss-module.htm?tagName=News"
photosFeedUrl = "http://www.baltimoreravens.com/cda-web/feeds/photo"

time = Date.today
title = "BaltimoreRavens.com Content from #{time.strftime("%Y-%m-%d")}"
output = "####{title}###\n\n"
videoRss = RSS::Parser.parse(videoFeedUrl, false)
output << "##Videos##\n\n"
videoRss.items.each do |item|
  if item.pubDate.to_date > time-1
    begin
      videoPageUrl = /<li class="download-audio "><a href="(.+)">/.match(Net::HTTP.get(URI(item.link)))[1]
      videoUrl = "#{/(.+)32k.mp3/.match(videoPageUrl)[1]}5000k.mp4"
      output << "[**#{item.title}**](#{videoUrl}) - #{item.description}\n\n"
    rescue
    end
  end
end

newsRss = RSS::Parser.parse(newsFeedUrl, false)
output << "##News##\n\n"
newsRss.items.each do |item|
  if item.pubDate.to_date > time-1
    output << "[**#{item.title}**](#{item.link}) - #{item.description}\n\n"
  end
end

photosRss = RSS::Parser.parse(photosFeedUrl, false)
output << "##Photos##\n\n"
photosRss.items.each do |item|
  if item.pubDate.to_date > time-1
    output << "[**#{item.title}**](#{item.link}) - #{item.description}\n\n"
  end
end

output << "-----------------------------------------\n\n"
output << "Hi, I am a reddit bot created by /u/_j_. Please send any comments, feedback, or requests as a pm to him."

puts output
puts "\n\n\n"
puts client.submit("[RavensBot]#{title}", "ravensbot", options={:text => output})
sleep(600)
puts client.submit("[RavensBot]#{title}", "ravens", options={:text => output})
