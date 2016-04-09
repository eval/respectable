# Respectable

Respectable allows you to structure your specs similar to [scenario outlines in Cucumber](https://github.com/cucumber/cucumber/wiki/Scenario-outlines).

![](./mel-kim.jpg)

So instead of:

```ruby
describe '#full_name' do
  it 'concats first and last' do
    expect(build(:user, first: 'Foo', last: 'Bar').full_name).to eq 'Foo Bar'
  end

  it 'does smart casing stuff' do
    expect(build(:user, first: 'Foo', last: 'Van Bar').full_name).to eq 'Foo van Bar'
  end

  it 'handles last being nil' do
    expect(build(:user, first: 'First', last: nil).full_name).to eq 'Foo'
  end

  it 'handles first being nil' do
    expect(build(:user, first: nil, last: 'Bar').full_name).to eq 'Bar'
  end
end
```

...you throw a bunch of cases at an expectation:

```
describe '#full_name' do
  it 'concats first and last' do
    each_row(<<-TABLE) do |first, last, expected|
      #| first | last    | expected    |
       | Foo   | Bar     | Foo Bar     |
       | Foo   | Van Bar | Foo van Bar |
       | Foo   | `nil`   | Foo         |
       | `nil` | Bar     | Bar         |
      TABLE

      expect(build(:user, first: first, last: last).full_name).to eq expected
    end
  end
end
```

You just got yourself a *table* in your *rspec*! (who told you naming was hard?)

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

Checkout the ![specs](spec/respectable_spec.rb)

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

