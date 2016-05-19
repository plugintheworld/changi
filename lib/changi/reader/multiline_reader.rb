require 'tempfile'

module Changi
  module Reader
    class MultilineReader
      def read attribute, _
        tmpfile = Tempfile.new 'changi'

        intro tmpfile, attribute

        rc = system "#{editor} '#{tmpfile.path.strip}'"
        if rc == false
          abort 'editor returned with non-zero exit status, abort'
        elsif rc.nil?
          puts "editor '#{editor}' not found, trying nano..."
          unless system "name '#{tmpfile.path.strip}'"
            abort 'nano not found or non-zero exit status, abort'
          end
        end

        read_and_strip(tmpfile).tap do |data|
          if attribute[:opts][:required] && data.empty?
            abort "required #{attribute[:name]} attribute empty, abort"
          end
        end
      ensure
        tmpfile.close
        tmpfile.unlink
      end

      private

      def intro tmpfile, attribute
        tmpfile.puts
        tmpfile.puts
        tmpfile.puts "# Please enter #{attribute[:name]} above."
        tmpfile.puts '# Lines starting with # will be ignored.'
        tmpfile.puts '# Empty tmpfile will abort the process.' if attribute[:opts][:required]
        tmpfile.sync
        tmpfile.close
      end

      def read_and_strip tmpfile
        tmpfile.open
        tmpfile.read.strip.split("\n").reject { |x| x =~ /^\s*#/ }
               .drop_while(&:empty?).reverse.drop_while(&:empty?).reverse
      end

      def editor
        editor_tests.lazy.map(&:call).find { |e| !(e.nil? || e.empty?) && editor_exists?(e) }.tap do |e|
          raise 'could not detect editor' unless e
        end
      end

      def editor_tests
        [
          -> { ENV['CHANGI_EDITOR'] },
          -> { ENV['EDITOR'] },
          -> { `git config core.editor`.strip },
          -> { 'nano' },
          -> { 'vim' }
        ]
      end

      def editor_exists? app
        # Assume existence of editor specifically set for us.
        return true if app == ENV['CHANGI_EDITOR']

        system "command -v #{app} >/dev/null 2>&1"
      end
    end
  end
end
