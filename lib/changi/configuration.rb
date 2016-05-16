module Changi
  class Configuration
    attr_accessor :changelog_path
    attr_accessor :entries_path
    attr_accessor :default_categories
    attr_accessor :updater
    attr_accessor :changelog_template

    def self.default
      new.tap do |config|
        config.changelog_path     = File.join Dir.pwd, 'changelog.md'
        config.entries_path       = File.join Dir.pwd, 'changelog'
        config.default_categories = []
        config.updater            = Updater::PrependUpdater
        config.changelog_template = <<-eod
# <%= release.version %>, <%= Time.now.strftime('%Y-%m-%d') %><%= release.notes and ", \#{release.notes}" %>
<% entry_set.entries.group_by(&:category).each do |category, entries| %>
## <%= category %>

<%=
  entries.map do |e|
    if e.text.is_a?(Array)
      e.text.map.with_index { |l, i| i == 0 ? "* \#{l}" : "  \#{l}" }.join("\n")
    else
      "* \#{e.text.gsub("\n", ' ')}"
    end
  end.join("\n")
%>
<% end %>
eod
      end
    end
  end
end
