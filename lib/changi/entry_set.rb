require 'fileutils'

module Changi
  class EntrySet
    attr_reader :config

    def initialize config
      @config = config
      FileUtils.mkdir_p @config.entries_path
    end

    def new_entry
      entries << Entry.build(self, make_entry_path).tap(&:save)
    end

    def entries
      @entries ||= yamls.map { |yml| Entry.load self, yml }
    end

    def entries_by_category
      entries.group_by &:category
    end

    def previous_categories
      entries.map &:category
    end

    def destroy_all
      entries.each &:destroy
    end

    private

    def yamls
      Dir["#{@config.entries_path}/*yml"]
    end

    def make_entry_path
      File.join @config.entries_path, make_entry_name
    end

    def make_entry_name
      if git_branch = `git rev-parse --abbrev-ref HEAD 2>/dev/null`.strip
        "#{Time.now.strftime('%y%m%d%H%M%S')}_from_#{git_branch}.yml"
      else
        "#{Time.now.strftime('%y%m%d%H%M%S')}.yml"
      end
    end
  end
end
