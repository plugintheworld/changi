require 'yaml'

module Changi
  class Entry
    include FlexibleAttributes

    class << self
      def build entry_set, yaml_path
        new(entry_set, yaml_path).tap(&:read_in_attributes)
      end

      def load entry_set, yaml_path
        new(entry_set, yaml_path).tap(&:read_in_yaml)
      end
    end

    define_attribute :category, reader: Reader::CategoryReader
    define_attribute :text, reader: Reader::MultilineReader, opts: { required: true }

    attr_reader :entry_set

    def initialize entry_set, path
      @entry_set = entry_set
      @path      = path
    end

    def read_in_yaml
      data = YAML.load_file @path
      self.class.attribute_names.each { |name| send "#{name}=".to_sym, data[name] }
    end

    def save
      File.open(@path, 'w') { |fd| fd.puts to_yaml }
    end

    def destroy
      git_rm || file_rm
    end

    private

    def to_yaml
      self.class.attribute_names.map { |name| [name, send(name.to_sym)] }.to_h.to_yaml
    end

    def git_rm
      system "git rm '#{@path}' >/dev/null 2>&1"
    end

    def file_rm
      FileUtils.rm_f @path
    end
  end
end
