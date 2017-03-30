
require 'rubygems'
require 'bundler/setup'

require 'win32/api'

require 'twitter'
require 'authconfig'

require 'uri'
require 'net/http'
require 'tmpdir'
require 'openssl'

include Win32

SPIF_UPDATEINIFILE = 1
SPI_SETDESKWALLPAPER = 20

SystemParametersInfo = API.new('SystemParametersInfo', 'IIPI', 'I', 'User32')

# TODO: Allow twitter API's CAs
# OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE


twitterClient = Twitter::REST::Client.new(twitterAuthConfig)
recentTweet = twitterClient.user_timeline('duckoftheday', count: 1, trim_user: true, exclude_replies: true, include_rts: false)
dailyDuckURL = URI(recentTweet[0].media[0].media_url)

Net::HTTP.start(dailyDuckURL.host) { |http|
  response = http.get(dailyDuckURL.path)
  filename = File.join(Dir.tmpdir, 'DuckofTheDay.' + dailyDuckURL.path.split('.').last)
  file = File.open(filename, 'wb')
  file.write(response.body)
  SystemParametersInfo.call(SPI_SETDESKWALLPAPER, 0, filename, SPIF_UPDATEINIFILE)

  file.close
  File.delete(filename)
}
