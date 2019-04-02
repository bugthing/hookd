require "yaml"

module Hookd
  class HookMatch
    def initialize(config)
      @config = config
    end

    def matches?(request)
      @request = request
      return false if should_match_headers? && !match_headers?
      return false if should_match_path? && !match_path?
      return false if should_match_json? && !match_json?
      true
    end

    private

    attr_reader :config, :request

    def should_match_headers?
      config.key? :header
    end

    def should_match_path?
      config.key? :path
    end

    def should_match_json?
      config.key? :json
    end

    def match_headers?
      config[:header].each_pair.all? do |key, value|
        req_key = key.to_s.upcase
        req_value = request.env[req_key] || request.env["HTTP_#{req_key}"]
        req_value == value
      end
    end

    def match_path?
      config[:path] == request.path
    end

    def match_json?
      req_json = JSON.parse(request.body.read)
      conf_json = JSON.parse(JSON.generate(config[:json]))
      (conf_json.to_a - req_json.to_a).empty?
    end
  end
end
