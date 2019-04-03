require_relative './hookd/version'
require_relative './hookd/configs'
require_relative './hookd/hook_match'
require_relative './hookd/rack_app'

require 'ostruct'

module Hookd
  class Error < StandardError; end

  def self.configure
    @config ||= OpenStruct.new
    yield(@config) if block_given?
    @config
  end

  def self.config
    @config || configure
  end

  def self.rack_app
    RackApp.new
  end
end
