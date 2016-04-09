require "respectable/version"
require 'csv'

module Respectable
  def self.included(base)
    base.extend Meat
    base.class_eval do
      include Meat
    end
  end

  module Meat
    def each_row(string, &block)
      string.split(/\n */).reject {|line| line[/^ *#/] }.map do |line|
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
  ::RSpec.configure do |config|
    config.include Respectable
  end
end
