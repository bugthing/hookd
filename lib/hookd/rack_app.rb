require "openssl"

module Hookd
  class RackApp
    def call(env)
      @request = Rack::Request.new env

      if Hookd.config.secret && request.env.key?("HTTP_X_HUB_SIGNATURE")
        begin
          verify_hmac!
        rescue Error => e
          return [401, {}, ["Not verified: #{e}"]]
        end
      end

      return [404, {}, ["Not hookd!"]] unless match

      HookAction.new(match.config).take_action

      [200, {}, ["hookd!"]]
    end

    private

    attr_reader :request

    def match
      @match ||= Configs.new.hooks.find { |hook| hook.matches?(request) }
    end

    def verify_hmac!
      signature = request.env["HTTP_X_HUB_SIGNATURE"]
      body = request.body.read
      request.body.rewind

      unless String(signature).start_with?("sha1=")
        raise Error, "secret checking enabled but no/invalid X-Hub-Secret"
      end

      signature = signature[5..-1]

      digest = OpenSSL::Digest.new("sha1")
      verify_signature = OpenSSL::HMAC.hexdigest(digest, Hookd.config.secret, body)

      raise Error, "invalid X-Hub-Signature - #{verify_signature}" if signature != verify_signature
    end
  end
end
