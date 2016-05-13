module Changi
  class Changelog
    def initialize config
      @config = config
    end

    def new_entry
      entry_set.new_entry
    end

    def render demo: false
      release  = demo ? Release.demo : Release.build
      renderer = Renderer.new @config, entry_set, release
      renderer.render
    end

    def update
      updater = @config.updater.new
      updater.update @config.changelog_path, render
      entry_set.destroy_all
    end

    private

    def entry_set
      @entry_set ||= EntrySet.new @config
    end
  end
end
