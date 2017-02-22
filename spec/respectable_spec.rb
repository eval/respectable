require 'spec_helper'

describe Respectable do
  it 'has a version number' do
    expect(Respectable::VERSION).not_to be nil
  end

  describe 'can be used within a describe-block' do
    specify_each(<<-TABLE) do |col1, col2|
| item1 | item 2 |
TABLE

      expect(col1).to match(/item1/)
    end
  end

  specify_each(<<-TABLE) do |col1, col2|
| item1 | item 2 |
TABLE

    expect(col1).to match(/item1/)
  end

  describe 'strips whitespace around a value' do
    specify_each(<<-TABLE, desc: "yields 'Hello world'") do |col1|
| Hello world |
|Hello world|
|   Hello world    |
TABLE

      expect(col1).to eq "Hello world"
    end
  end

  describe 'skips lines prefixed with a #' do
    specify_each(<<-TABLE) do |col1|
    #| Hello world |
    #  | Hello world |
    | skip |
TABLE
      expect { raise "I was yielded to :(" unless col1 == 'skip' }.to_not raise_error
    end
  end

  describe 'preserves escaped |' do
    specify_each(<<-TABLE) do |col1|
| Containing a \\| |
TABLE

      expect(col1).to eq 'Containing a |'
    end
  end

  describe 'evaluates values between `...`' do
    let(:a) { 1 }

    def b
      2
    end

    specify_each(<<-TABLE) do |input, expected|
| `:symbol` | :symbol |
| `1`       | 1       |
| `a`       | 1       |
| `b`       | 2       |
TABLE

      expect(input).to eq eval(expected)
    end
  end

  describe 'works when indented' do
    specify_each(<<-TABLE) do |col1|
      | col1 |
      | col1 |
      TABLE

      expect(col1).to match(/col1/)
    end
  end

  describe 'allows trailing comments' do
    specify_each(<<-TABLE, desc: nil) do |col1, col2|
      | col1 | # some comment
      | col1 | # `raise`
      TABLE

      expect(col2).to be_nil
    end
  end

  describe 'using helper methods and custom description' do
    def full_name(first, last)
      [first, last].compact.join(' ')
    end

    specify_each(<<-TABLE, desc: "full_name(%{first}, %{last}) => %{result}") do |first, last, result|
                              | Foo | `nil` | Foo     |
                              | Foo | Bar   | Foo Bar |
      TABLE


      expect(full_name(first, last)).to eq result
    end
  end
end
