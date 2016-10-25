# Respectable

[![build status](https://gitlab.com/eval/respectable/badges/master/build.svg)](https://gitlab.com/eval/respectable/commits/master)

Respectable allows you to structure your specs similar to [scenario outlines in Cucumber](https://github.com/cucumber/cucumber/wiki/Scenario-outlines).

![](logo.jpg)

So instead of:

```ruby
describe '#full_name' do
  it 'concats first and last' do
    expect(User.new(first: 'Foo', last: 'Bar').full_name).to eq 'Foo Bar'
  end

  it 'does smart casing stuff' do
    expect(User.new(first: 'Foo', last: 'Van Bar').full_name).to eq 'Foo van Bar'
  end

  it 'handles last being nil' do
    expect(User.new(first: 'First', last: nil).full_name).to eq 'Foo'
  end

  it 'handles first being nil' do
    expect(User.new(first: nil, last: 'Bar').full_name).to eq 'Bar'
  end
end
```

...you throw a bunch of cases at an expectation:

```ruby
describe '#full_name' do
  specify_each(<<-TABLE) do |first, last, expected|
    #| first | last    | expected    |
     | Foo   | Bar     | Foo Bar     |
     | Foo   | Van Bar | Foo van Bar |
     | Foo   | `nil`   | Foo         |
     | `nil` | Bar     | Bar         |
    TABLE

    expect(User.new(first: first, last: last).full_name).to eq expected
  end
end
```

You just got yourself a *table* in your *rspec*! (who told you naming was hard?)

## Details

### Literal values

By default values from the table are passed to the block as stripped strings. For more expressiveness you can use backticks; this allows you to pass literal values (e.g. \`nil\`, \`:some_symbol\`, \`true\`, \`1 + 1\`) to the block.

### Description

For every row in the table an it-block is created. The description of this block will be of the format:  
`column1-name: "cell-value", column2-name: "cell-value" yields "value of last column"`.  
So for the full_name-example above the full RSpec-output (using `--format documentation`) is:  
```
#full_name
  first: "Foo", last: "Bar" yields "Foo Bar"
  first: "Foo", last: "Van Bar" yields "Foo van Bar"
  first: "Foo", last: "`nil`" yields "Foo"
  first: "`nil`", last: "Bar" yields "Bar"
```

You can customize the description by passing a template to `specify_each` in which you can use the block parameters, e.g.:  
```ruby
specify_each(<<-TABLE, desc: 'full_name(%{first}, %{last}) => %{expected}') do |first, last, expected|
```

If you want the standard RSpec-description you can pass `desc: nil` to `specify_each`.

### Comments

Just like in Ruby, you can comment (the remainder of) a line by using `#`. This helps to document the table:  
```ruby
specify_each(<<-TABLE) do |arg1, arg2, result|
  # | arg1 (never negative) | arg2 | +  |
    | 1                     |   2  | 3  |
    | 10                    |   2  | 12 | # <= important edge-case
TABLE
  expect(...)
end
```

### Various

You can escape the pipe character (`|`) by prefixing it with `\\`:
```
| This table has one cell with a \\| |
```

## Installation

Add this line to your application's Gemfile:

```ruby
group :test do
  gem 'respectable', require: false
end
```

Then in `rails_helper.rb` or `spec_helper.rb`:

```
require 'respectable'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install respectable

## Usage

Checkout the [specs](spec/respectable_spec.rb).

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

