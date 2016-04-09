require "respectable/version"
require 'csv'

module Respectable
  def self.included(base)
    base.extend Meat
    base.send(:include, Meat)
  end

  module Meat
    def each_row(string, &block)
      string.split(/\n */).grep(/^[^#]/).map do |line|
        yield(*line.split(/ *(?<!\\)\| */)[1..-1].map do |i|
          i = i.sub(/\\(?=|)/, '') # remove escapes for '|'
          # handle `...`
          r = i[/\A`([^`]+)`\z/, 1]
          r ? eval(r) : i
        end)
      end
    end
  end
end

if defined?(RSpec)
  RSpec.configure do |config|
    send(:include, Respectable)
  end
end
