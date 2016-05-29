require 'redditkit'
require 'rss'
require 'date'
require 'net/http'
require 'json'

userPassFile = File.read('russellBot.json')
userPassHash = JSON.parse(userPassFile)

client = RedditKit::Client.new userPassHash['username'], userPassHash['password']

videoFeedUrl = "http://www.seahawks.com/rss/video"
newsFeedUrl = "http://www.seahawks.com/rss/article"
photosFeedUrl = "http://www.seahawks.com/rss/gallery"

time = Date.today
title = "Seahawks.com Content from #{time.strftime("%Y-%m-%d")}"
output = "####{title}###\n\n"
videoRss = RSS::Parser.parse(videoFeedUrl, false)
output << "##Videos##\n\n"
videoRss.items.each do |item|
  if item.pubDate.to_date > time-1
    begin
      videoPageUrl = /<a href=\"(.+.mp3)(.+)Download audio/.match(Net::HTTP.get(URI(item.link)))[1]
      videoUrl = "#{/(.+)32k.mp3/.match(videoPageUrl)[1]}5000k.mp4"
      output << "[**#{item.title}**](#{videoUrl}) - #{item.description}\n\n"
    rescue
      puts 'error'
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
puts "-------------------------------------------\nSubmitting to log subreddit\n-----------------------------------------------------------"
puts client.submit("[Russell_Bot] #{title}", "russell_bot", options={:text => output})
puts "--------------------------------------------------\nSleeping for 10 minutes so we don't time out\n--------------------------------------------------------"
sleep(600)
puts "--------------------------------------------------\nSubmitting to Seahawks subreddit\n-------------------------------------------------------"
puts client.submit("[Russell_Bot] #{title}", "seahawks", options={:text => output})
puts "--------------------------------------------------\nDone!\n-------------------------------------------"
