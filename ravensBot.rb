require 'redditkit'
require 'rss'
require 'date'
require 'net/http'
client = RedditKit::Client.new 'ravensbot', 'baltimore'

videoFeedUrl = "http://www.baltimoreravens.com/cda-web/rss-module.htm?tagName=Videos"
newsFeedUrl = "http://www.baltimoreravens.com/cda-web/rss-module.htm?tagName=News"
photosFeedUrl = "http://www.baltimoreravens.com/cda-web/feeds/photo"

time = Date.today


videoRss = RSS::Parser.parse(videoFeedUrl, false)
videoRss.items.each do |item|
  if item.pubDate.to_date > time-2
    begin
      videoPageUrl = /<li class="download-audio "><a href="(.+)">/.match(Net::HTTP.get(URI(item.link)))[1]
      videoUrl = "#{/(.+)32k.mp3/.match(videoPageUrl)[1]}5000k.mp4"
      puts "#{item.pubDate} - #{item.title}"
      puts videoUrl
    rescue
    end
  end
end

title = "BaltimoreRavens.com Content from #{time.strftime("%Y-%m-%d")}"
output = "text"
#puts "#{title}\n#{output}"
#client.submit(title, "ravensbot", options={"text" => output})
