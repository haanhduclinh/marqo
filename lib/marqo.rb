# frozen_string_literal: true

require 'uri'
require 'net/http'

require_relative 'marqo/version'
require_relative 'marqo/configuration'
require_relative 'marqo/helpers/url_helpers'
require_relative 'marqo/helpers/request_helpers'
require_relative 'marqo/index'
require_relative 'marqo/document'
require_relative 'marqo/search'
require_relative 'marqo/models'
require_relative 'marqo/device'
require_relative 'marqo/client'

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
