require 'changi'

namespace :changi do
  desc 'Create a new changelog entry'
  task :new do
    Changi.changelog.new_entry
  end

  desc 'Show changelog for next release'
  task :diff do
    puts Changi.changelog.render demo: true
  end

  desc 'Update project changelog for release'
  task :update do
    Changi.changelog.update
    puts 'Changelog updated, and changelog directory cleared.'
    puts 'Check if there were manual changes to changelog.md and merge them before committing.'
  end
end
