# Description:
#   Hubot News Fetcher - works with well formed feeds
#
# Dependencies:
#   "nodepie": "0.5.0"
#
# Configuration:
#   None
#
# Commands:
#   hubot strib me[N] - returns N headlines from the Star Tribune, if N is blank, returns top headline
#   hubot hn me[N] - returns N headlines from Hacker News, if N is blank, returns top headline
#   hubot cnn me[N] - returns N headlines from CNN, if N is blank, returns top headline
#
# Author:
#   eric@softwareforgood based on a hacker news script form skimbriel

NodePie = require("nodepie")

error_msg = "Hmmmm, something's gone wrong."

local_news_url = "http://www.startribune.com/local/index.rss2"
hn_news_url = "https://news.ycombinator.com/rss"
cnn_news_url = "http://rss.cnn.com/rss/cnn_topstories.rss"
al_jazeera_url = "http://america.aljazeera.com/content/ajam/articles.rss"
wsj_url = "http://online.wsj.com/xml/rss/3_7014.xml"

fetch_news = (news_source, msg) ->
  msg.http(news_source).get() (err, res, body) ->
    if res.statusCode is not 200
      msg.send error_msg
    else
      feed = new NodePie(body)
      try
        feed.init()
        count = msg.match[1] || 1
        items = feed.getItems(0, count)
        msg.send item.getTitle() + ": " + item.getPermalink() for item in items
      catch e
        console.log(e)
        msg.send error_msg

module.exports = (robot) ->
  robot.respond /strib me(\d+)?/i, (msg) ->
    fetch_news local_news_url, msg

  robot.respond /hn me(\d+)?/i, (msg) ->
    fetch_news hn_news_url, msg

  robot.respond /cnn me(\d+)?/i, (msg) ->
    fetch_news cnn_news_url, msg

  robot.respond /aje me(\d+)?/i, (msg) ->
    fetch_news al_jazeera_url, msg

  robot.respond /wsj me(\d+)?/i, (msg) ->
    fetch_news wsj_url, msg

