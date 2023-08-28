# frozen_string_literal: true

require_relative 'marqo/version'
require_relative 'marqo/configuration'
require_relative 'marqo/index'

module Marqo
  class Error < StandardError; end
  # Your code goes here...

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    yield(configuration)
  end
end
