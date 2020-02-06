require_relative './config/environment'
require './app'

$stdout.sync = true

run App
