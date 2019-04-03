require "yaml"

module Hookd
  class Configs
    CONFIGS_DIR = File.join(File.dirname(File.expand_path(".", __FILE__)), "configs")

    def initialize
      @dir = Hookd.config.config_dir || CONFIGS_DIR
    end

    def config_files
      Dir.glob("#{dir}/*.yml")
    end

    def hooks
      config_files.flat_map { |yaml_file|
        YAML.safe_load(File.new(yaml_file).read, symbolize_names: true)
      }.map { |h| HookMatch.new(h) }
    end

    private

    attr_reader :dir
  end
end
