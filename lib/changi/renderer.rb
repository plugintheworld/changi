require 'erb'

module Changi
  class Renderer
    attr_reader :entry_set
    attr_reader :release

    def initialize config, entry_set, release
      @config  = config
      @entry_set = entry_set
      @release   = release
    end

    def render
      ERB.new(@config.changelog_template).result binding
    end
  end
end
