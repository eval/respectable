require 'respectable/version'

module Respectable
  def self.included(base)
    base.extend Interface
    base.class_eval do
      include Interface
    end
  end

  module Interface
    def specify_each(table, **options, &block)
      desc_template = options.has_key?(:desc) ? options[:desc] : Util.desc_template(block.parameters)

      define_method(:specify_each) do |*, &block|
        block.call(*@args) if @args
      end

      Util.table_data(table).each do |row|
        # TODO: can we use raw row-value? (for outline)
        desc_data = Hash[block.parameters.map(&:last).zip(row.map(&:inspect))]
        description = desc_template % desc_data if desc_template
        instance_eval(<<-IT, *block.source_location)
          it(description) do
            @args = Util.eval_row_items(row, binding)
            eval(block.source, binding, *block.source_location)
          end
        IT
      end
    end

    def each_row(table, **options, &block)
      RSpec.deprecate(:each_row, replacement: :specify_each)

      specify_each(table, **options, &block)
    end
  end

  module Util
    def self.desc_template(block_params)
      *desc_args, desc_result = *block_params.map(&:last)
      "yields %{#{desc_result}} for " + desc_args.map {|arg| "#{arg}: %{#{arg}}" }.join(', ')
    end

    def self.table_data(table)
      table.split(/\n */).reject {|line| line[/^ *#/] }.map do |line|
        cols = line.split(/ *(?<!\\)\| */)[1..-1]
        comment_col = cols.size
        cols.each_with_index {|col, ix| comment_col = ix if col[/^ *#/] }
        cols[0, comment_col]
      end
    end

    def self.eval_row_items(row, binding)
      row.map do |i|
        i = i.sub(/\\(?=|)/, '') # remove escapes for '|'
        # handle `...`
        r = i[/\A`([^`]+)`\z/, 1]
        r ? binding.eval(r) : i
      end
    end
  end
end

if defined?(RSpec)
  ::RSpec.configure do |config|
    config.include Respectable
  end
end
