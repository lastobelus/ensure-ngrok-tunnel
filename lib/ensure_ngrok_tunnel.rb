require "ensure_ngrok_tunnel/version"

module EnsureNgrokTunnel
  def self.start(config:, port: nil)
    require 'json'
    require 'open-uri'

    port ||= config[:addr] || ENV.fetch("PORT")

    ngrok_url = false
    ngrok_process = nil
    ngrok = nil
    ngrok_url = 'http://localhost:4040/api/tunnels'

    begin
      puts "checking ngrok for tunnels"
      ngrok = open(ngrok_url).read
    rescue
      if ngrok_process
        puts "waiting for ngrok..."
        sleep 0.5
      else
        puts "starting ngrok..."
        ngrok_process = spawn('ngrok start --none')
        Process.detach(ngrok_process)
      end
      retry
    end

    retries = 0

    begin
      ngrok = JSON.parse(ngrok)
      tunnel = ngrok['tunnels'].detect{|t| t['config']['addr'].split(':').last.to_s == port.to_s}
      if tunnel
        ngrok_url = tunnel.fetch('public_url')
      else
        puts "could not find tunnel..."
        raise "not found"
      end
    rescue
      retries += 1
      name = config[:name] || config[:hostname] || config[:subdomain] || ENV.fetch('DOMAIN', '????')
      begin
        response = RestClient.post ngrok_url, config.to_json, {content_type: :json, accept: :json}
      rescue => e
        puts "error starting tunnel: #{e.inspect}\n#{e.response.body.inspect}"
      end
      sleep 0.5
      puts "retrying"
      ngrok = open(ngrok_url).read
      retry unless retries > 5
    end

    ngrok_url
  end
end
