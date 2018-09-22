
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "ensure_ngrok_tunnel/version"

Gem::Specification.new do |spec|
  spec.name          = "ensure_ngrok_tunnel"
  spec.version       = EnsureNgrokTunnel::VERSION
  spec.authors       = ["Michael Johnston"]
  spec.email         = ["lastobelus@mac.com"]

  spec.summary       = %q{Ensure an ngrok tunnel is started}
  spec.description   = %q{This tiny gem has a singular purpose: ensure there is an ngrok tunnel running for the specified port.}
  spec.homepage      = "https://github.com/lastobelus/ensure_ngrok_tunnel"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"

  spec.add_dependency "rest-client"
  spec.add_dependency "json"
end
