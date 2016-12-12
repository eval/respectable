$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'respectable'

RSpec.configure do |config|
  config.color = true
  config.tty = true
end
