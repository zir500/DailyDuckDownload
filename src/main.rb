require 'rubygems'
require 'bundler/setup'

require 'win32/api'


include Win32
SPIF_UPDATEINIFILE = 1
SPI_SETDESKWALLPAPER = 20

SystemParametersInfo = API.new('SystemParametersInfo', 'IIPI', 'I', 'User32')

pathToNewBackground = "E:\\Users\\Zain\\Pictures\\Arnold.jpg"

SystemParametersInfo.call(SPI_SETDESKWALLPAPER, 0, pathToNewBackground, SPIF_UPDATEINIFILE)
