require 'spec_helper'

describe Respectable do
  it 'has a version number' do
    expect(Respectable::VERSION).not_to be nil
  end

  it 'can be used within examples' do
    each_row(<<-TABLE) do |col1, col2|
| item1 | item 2 |
TABLE

      expect(col1).to match /item1/
    end
  end

  each_row(<<-TABLE) do |col1, col2|
| item1 | item 2 |
TABLE
    it "can be used outside examples" do
      expect(col1).to match /item1/
    end
  end

  it 'strips whitespace around a value' do
    each_row(<<-TABLE) do |col1|
| Hello world |
|Hello world|
|   Hello world    |
TABLE

      expect(col1).to eq "Hello world"
    end
  end

  it 'skips lines prefixed with a #' do
    expect {
      each_row(<<-TABLE) do |col1|
#| Hello world |
 #  | Hello world |
TABLE
        raise "I was yielded to :("
      end
    }.to_not raise_error
  end

  it 'preserves escaped |' do
    each_row(<<-TABLE) do |col1|
| Containing a \\| |
TABLE

      expect(col1).to eq 'Containing a |'
    end
  end

  it 'evaluates values between `...`' do
    each_row(<<-TABLE) do |input, expected|
| `:symbol` | :symbol |
| `1`       | 1       |
TABLE

      expect(input).to eq eval(expected)
    end
  end

  it 'works when indented' do
    each_row(<<-TABLE) do |col1|
      | col1 |
      | col1 |
      TABLE

      expect(col1).to match /col1/
    end
  end
end
