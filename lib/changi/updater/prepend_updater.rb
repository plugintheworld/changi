module Changi
  module Updater
    class PrependUpdater
      def update changelog_path, release_data
        previous = File.read changelog_path if File.exist? changelog_path

        File.open changelog_path, 'w' do |fd|
          fd.puts release_data
          fd.puts
          fd.puts previous if previous
        end
      end
    end
  end
end
