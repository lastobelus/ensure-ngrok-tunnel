# EnsureNgrokTunnel

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/ensure_ngrok_tunnel`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'ensure_ngrok_tunnel'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ensure_ngrok_tunnel

## Usage

In your development.rb, call `EnsureNgrokTunnel.start` with a [valid ngrok config](https://ngrok.com/docs#config). If you have tunnels defined in your global ngrok config, this could just be `{name: 'name-of-my-tunnel'}`.

To determine whether the tunnel already exists, `EnsureNgrokTunnel` just looks for any tunnel bound to the port specified by `addr` in the config, or if not set, in `ENV['PORT']`. If you are using a config that just specifies a tunnel by name, you can optionally pass the port  as `port: XXXX`.

`EnsureNgrokTunnel` returns the tunnel url.

Example:
```ruby
  server_port = ENV.fetch('PORT')
  ngrok_url = EnsureNgrokTunnel.start(
    config: {
      name: Rails.application.class.parent.name.underscore,
      addr: server_port,
      proto: 'tls',
      hostname: ENV.fetch('API_DOMAIN'),
      key: Rails.root.join('certificates', 'development-key.pem').to_s,
      crt: Rails.root.join('certificates', 'development-cert.pem').to_s
    },
    port: server_port
  )

  puts "[NGROK] tunneling at " + ngrok_url
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/lastobelus/ensure_ngrok_tunnel.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
