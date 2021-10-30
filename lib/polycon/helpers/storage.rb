# frozen_string_literal: true

module Polycon
  module Helpers
    module Storage
      def self.get_path(*args)
        File.join(ENV['STORAGE_PATH'] || "#{ENV['HOME']}/.polycon", args)
      end

      def self.file_exists?(dir = '', name = '')
        File.exist?(get_path(dir, name))
      end

      def self.create_dir(dir = '')
        FileUtils.mkdir_p(get_path(dir))
      end

      def self.write(professional, date, *data)
        File.write(get_path(professional, "#{date}.paf"), data.join("\n"), mode: 'w+')
      end

      def self.read_file(dir, file)
        File.read(get_path(dir, "#{file}.paf")).split("\n")
      end

      def self.get_files(dir = '')
        Dir.children(get_path(dir))
      end

      def self.remove(dir, file = '')
        FileUtils.rm_rf(get_path(dir, file))
      end

      def self.rename(old_name, new_name, directory = '')
        FileUtils.move(get_path(directory, old_name), get_path(directory, new_name))
      end

      def self.write_with_template(template, filename, data)
        File.write(filename, erb_result = ERB.new(template_read(template)).result_with_hash(data), mode: 'w+')
      end
      def self.template_read(filename)
        File.read(File.join(ENV['PWD'] ,'lib/polycon/templates', filename))
      end
    end
  end
end
