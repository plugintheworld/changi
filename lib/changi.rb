require 'changi/tasks'

module Changi
  Configuration = Struct.new :changelog_path, :changelog_entry_path, :default_categories

  def self.configuration
    @configuration ||= Configuration.new './changelog.md', './changelog', []
  end

  def self.configure
    yield configuration
  end
end
