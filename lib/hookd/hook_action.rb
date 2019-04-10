module Hookd
  class HookAction
    def initialize(match)
      @config = match.config
      @json = match.request_json
    end

    def take_action
      case config[:action].to_sym
      when :print
        puts config[:message]
      when :cmd
        `#{parse_templated_command}`
      end
    end

    private

    attr_reader :config, :json

    def parse_templated_command
      ERB.new(config[:command]).result(binding)
    end
  end
end
