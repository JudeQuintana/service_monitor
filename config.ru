$LOAD_PATH.push File.expand_path('../lib', __FILE__)
require 'sinatra/base'
require 'service_monitor'
require 'service_monitor/app'

run ServiceMonitor::App
