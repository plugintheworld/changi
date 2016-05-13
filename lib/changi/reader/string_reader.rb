require 'highline'

module Changi
  module Reader
    class StringReader
      def read attribute, owner
        cli.ask("#{attribute[:name]}: ").tap do |x|
          if attribute[:opts][:required] && [nil, ''].include?(x)
            abort "required #{attribute[:name]} attribute empty, abort"
          end
        end
      end

      protected

      def cli
        @cli ||= HighLine.new
      end
    end
  end
end
