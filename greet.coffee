# Description:
#   Greet user with info
#
# Commands:
#   hubot greet

module.exports = (robot) ->
  robot.respond /(greet)$/i, (msg) ->
    msg.send "Greetings!"
    sunInfo msg, (response) ->
      msg.send response
    exchangeRates msg, (response) ->
      msg.send response
    stockInfo msg, (response) ->
      msg.send response
    guardianNews msg, (response) ->
      msg.send response

Wolfram = require('wolfram').createClient(process.env.HUBOT_WOLFRAM_APPID)

guardianNews = (msg, cb) ->
  msg.http('http://content.guardianapis.com/search?section=uk-news%20%7C%20world&page-size=3&api-key=<nope>')
  .get() (err, res, body) ->
    result = JSON.parse(body)
    cb "### Guardian News:"
    for item in result.response.results
      cb item.webTitle

stockInfo = (msg, cb) ->
  # FTSE
  msg.http('http://finance.google.com/finance/info?client=ig&q=INDEXFTSE%3AUKX')
    .get() (err, res, body) ->
      result = JSON.parse(body.replace(/\/\/ /, ''))
      cb "FTSE100 " + result[0].l_fix + "(#{result[0].c})"
  # Brent Crude
  msg.http('http://finance.google.com/finance/info?client=ig&q=EPA:BRNTB')
    .get() (err, res, body) ->
      result = JSON.parse(body.replace(/\/\/ /, ''))
      cb "SP BRENT CRUDE OIL " + result[0].l_fix + "(#{result[0].c})"

exchangeRates = (msg, cb) ->
  msg.http("http://api.fixer.io/latest?base=GBP")
    .get() (err, res, body) ->
      result = JSON.parse(body)
      cb '### GBP buys:'
      cb result['rates']['USD'] + ' USD'
      cb result['rates']['EUR'] + ' EUR'
      cb result['rates']['CNY'] + ' CNY'
  msg.http("https://api.bitcoinaverage.com/exchanges/GBP")
    .get() (err, res, body) ->
      result = JSON.parse(body)
      cb '### BTC buys:'
      cb result['bitbargain']['rates']['ask'] + ' GBP'

weatherInfo = (msg, cb) ->
  # Weather
  Wolfram.query 'weather forecast London', (e, result) ->
    # console.log result
    if result and result.length > 0
      cb "Weather: " + result[1]['subpods'][0]['value']
    else
      cb 'Hmm...not sure yo momma'

sunInfo = (msg, cb) ->
  console.log msg.match
  # Sunrise
  Wolfram.query 'sunrise UK', (e, result) ->
    # console.log result
    if result and result.length > 0
      cb "Sunrise: " + result[1]['subpods'][0]['value'].replace /\(.*\)/, ""
    else
      cb 'Hmm...not sure yo momma'
  # Sunset
  Wolfram.query 'sunset UK', (e, result) ->
    # console.log result
    if result and result.length > 0
      cb "Sunset: " + result[1]['subpods'][0]['value'].replace /\(.*\)/, ""
    else
      cb 'Hmm...not sure yo momma'

