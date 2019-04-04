module Hookd
  class HookAction
    def initialize(config)
      @config = config
    end

    def take_action
      case config[:action].to_sym
      when :print
        puts config[:message]
      end
    end

    private

    attr_reader :config
  end
end
