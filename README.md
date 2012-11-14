# EM::Statsd

A drop-in extension/replacement to the statsd-ruby gem.

## Installation

Add this line to your application's Gemfile:

    gem 'em-statsd'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install em-statsd

## Usage

Replace all occurances of the Statsd constant with
EM::Statsd in your app, inside an EM::run block. 
It all works through the magic of adapter objects.

```ruby
gem 'em-statsd'
require 'em/statsd'

EM::Statsd.logger = Logger.new(STDERR)
EM.run { 
  statsd = EM::Statsd.new('localhost', 12345); 
  EM.next_tick { statsd.increment("kittens") }
}
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
