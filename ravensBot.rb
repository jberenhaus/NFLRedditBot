require 'redditkit'

client = RedditKit::Client.new 'ravensbot', 'baltimore'
puts client.signed_in?





title = "title"
output = "text"

client.submit(title, "ravensbot", options={"text" => output})
