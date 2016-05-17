require 'minitest/mock'
require 'minitest/autorun'
require 'changi'

module TestHelper
  def self.changelog_path
    File.expand_path '../root/changelog.yml', __FILE__
  end

  def self.entries_path
    File.expand_path '../root/entries', __FILE__
  end

  def self.cli
    @cli ||= MiniTest::Mock.new
  end

  def setup_root
    FileUtils.mkdir_p File.expand_path('../root', __FILE__)
  end

  def teardown_root
    FileUtils.rm_r File.expand_path('../root', __FILE__)
  end

  def cli
    TestHelper.cli
  end

  def changelog
    Changi::Changelog.new Changi.configuration
  end

  def entries_yamls
    Dir["#{TestHelper.entries_path}/*yml"]
  end

  def entries_count
    entries_yamls.size
  end

  def last_entry_yaml
    entries_yamls.sort.last
  end
end

module Changi
  module Reader
    class StringReader
      protected

      def cli
        TestHelper.cli
      end
    end

    class MultilineReader
      private

      def editor
        "echo 'Multiline' > "
      end
    end
  end
end

Changi.configure do |config|
  config.changelog_path = TestHelper.changelog_path
  config.entries_path = TestHelper.entries_path

  config.changelog_template = <<-eod
:changelog:
  :version: <%= release.version %>
  :notes: <%= release.notes %>
  :entries:
    <% entry_set.entries.each do |entry| %>
    -
      :category: <%= entry.category %>
      :text: <%= entry.text.join(' ') %>
    <% end %>
eod
end
