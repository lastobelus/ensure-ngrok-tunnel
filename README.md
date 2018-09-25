# EnsureNgrokTunnel
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

If an instance of ngrok is already running on the standard port (4040), `EnsureNgrokTunnel` will talk to it, otherwise it spawns one with `ngrok start --none` (this instance should die when the parent process does, though with rails development the usual spring/fs-watch shenanigans will probably occasionally result in zombied ngroks).

`EnsureNgrokTunnel` returns the tunnel url.

Example:
```ruby
  server_port = ENV.fetch('TUNNEL_PORT')
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

**NOTE:** be careful about using the standard PORT env var in Rails with sidekiq. When using heroku local & a Procfile with web & worker processes, the PORT variable seems to get incremented by 100 in the worker process, which will cause `EnsureNgrokTunnel` not to find the tunnel in whichever is the second process to launch.

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/lastobelus/ensure_ngrok_tunnel.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
