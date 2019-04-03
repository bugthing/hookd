require "openssl"

module Hookd
  class RackApp
    def call(env)
      request = Rack::Request.new env

      secret = Hookd.config.secret

      if secret && request.env.key?("HTTP_X_HUB_SIGNATURE") && !verify_hmac(secret, request)
        [401, {}, ["Not verified"]]
      end

      if request.env.key?("HTTP_X_GITHUB_EVENT")
        [200, {}, ["hook for #{request.env["HTTP_X_GITHUB_EVENT"]}"]]
      else
        [404, {}, ["Not hookd!"]]
      end
    end

    private

    attr_reader :secret, :config_dir, :script_dir

    def match(request)
      Configs.new.hooks.each do |hook|
      end
    end

    def verify_hmac(secret, request)
      signature = request.env["HTTP_X_HUB_SIGNATURE"]
      body = request.body.read

      unless String(signature).start_with?("sha1=")
        raise ArgumentError, "secret checking enabled but no/invalid X-Hub-Secret"
      end

      signature = signature[5..-1]

      digest = OpenSSL::Digest.new("sha1")
      verify_signature = OpenSSL::HMAC.hexdigest(digest, secret, body)

      raise Error, "invalid X-Hub-Signature - #{verify_signature}" if signature != verify_signature
    end
  end
end
