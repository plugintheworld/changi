module Changi
  class Release
    include FlexibleAttributes

    class << self
      def build
        new.tap(&:read_in_attributes)
      end

      def demo
        new.tap do |inst|
          attribute_names.each { |name| inst.send "#{name}=".to_sym, "<#{name}>" }
        end
      end
    end

    define_attribute :version
    define_attribute :notes
  end
end
