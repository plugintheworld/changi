namespace :changi do
  def yamls
    Dir["#{Changi.configuration.changelog_entry_path}/*yml"]
  end

  def entries
    yamls.map { |f| YAML.load_file f }
  end

  def entries_by_category
    entries.group_by { |x| x[:category] }
  end

  def categories
    (entries.map { |x| x[:category] } + Changi.configuration.default_categories).uniq
  end

  def make_entry_name
    if git_branch = `git rev-parse --abbrev-ref HEAD 2>/dev/null`.strip
      "#{Time.now.strftime('%y%m%d%H%M%S')}_from_#{git_branch}.yml"
    else
      "#{Time.now.strftime('%y%m%d%H%M%S')}.yml"
    end
  end

  def render_changelog release_number, release_notes
    out = StringIO.new
    out << "# #{release_number}, #{Time.now.strftime('%Y-%m-%d')}"
    out << ", #{release_notes}" unless release_notes.empty?
    out << "\n\n"

    entries_by_category.each do |c, es|
      out << "## #{c}\n\n"
      es.each { |e| out << "* #{e[:text]}\n" }
      out << "\n"
    end

    out
  end

  desc 'Create a new changelog entry'
  task :new do
    require 'highline/import'
    require 'fileutils'
    require 'yaml'

    FileUtils.mkdir_p Changi.configuration.changelog_entry_path

    data = {}

    puts 'Category:'
    data[:category] = choose do |menu|
      menu.choices(*categories)
      menu.choice('Other (create new)') do
        ask 'Please insert category:'
      end
      menu.choice('Abort') { exit }
    end

    data[:text] = ask 'Please insert text:'

    File.open(File.join(Changi.configuration.changelog_entry_path, make_entry_name), 'w') do |fd|
      fd.puts data.to_yaml
    end
  end

  desc 'Show changelog for next release'
  task :diff do
    require 'yaml'
    puts render_changelog('<next release number>', '').string
  end

  desc 'Update project changelog for release'
  task :update do
    require 'highline/import'
    require 'fileutils'
    require 'yaml'

    release_number = ask 'Release number:'
    release_notes  = ask 'Release notes (leave empty for none):'

    out = render_changelog release_number, release_notes

    out << File.read(Changi.configuration.changelog_path) rescue nil

    File.open(Changi.configuration.changelog_path, 'w') do |fd|
      fd.puts out.string
    end

    yamls.each do |yml|
      unless system "git rm '#{yml}' >/dev/null 2>&1"
        FileUtils.rm_f yml
      end
    end

    puts 'Changelog updated, and changelog directory cleared.'
    puts 'Check if there were manual changes to changelog.md and merge them before committing.'
  end
end
