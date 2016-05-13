module Changi
  module FlexibleAttributes
    module ClassMethods
      def attributes
        @attributes ||= []
      end

      def attribute_names
        attributes.map { |x| x[:name] }
      end

      def define_attribute name, reader: Reader::StringReader, opts: {}, &block
        attr_accessor name.to_sym

        attributes << {
          name: name,
          reader: (block_given? ? block : ->(*args) { reader.new.read *args }),
          opts:   opts
        }
      end
    end

    def self.included base
      base.extend ClassMethods
    end

    def read_in_attributes
      self.class.attributes.each do |data|
        send "#{data[:name]}=".to_sym, data[:reader].call(data, self)
      end
    end
  end
end
