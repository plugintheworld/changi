require 'changi/reader/string_reader'
require 'changi/reader/multiline_reader'
require 'changi/reader/category_reader'
require 'changi/updater/prepend_updater'
require 'changi/flexible_attributes'
require 'changi/changelog'
require 'changi/configuration'
require 'changi/entry'
require 'changi/entry_set'
require 'changi/release'
require 'changi/renderer'

module Changi
  class << self
    def configuration
      @configuration ||= Configuration.default
    end

    def configure
      yield configuration
    end

    def changelog
      @changelog ||= Changelog.new configuration
    end
  end
end
