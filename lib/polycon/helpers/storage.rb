module Polycon
  module Helpers
    module Storage
      def self.get_path(*args)
        File.join(ENV['STORAGE_PATH'] || '/tmp/ttps-ruby-storage', args)
      end

      def self.file_exists?(dir = '', name = '')
        File.exist?(get_path(dir, name))
      end

      def self.create_dir(dir = '')
        FileUtils.mkdir_p(get_path(dir))
      end

      def self.create_file(professional, date, *data)
        File.write(get_path(professional, "#{date}.paf"), data.join("\n"))
      end

      def self.read_file(dir, file)
        File.read(get_path(dir, "#{file}.paf")).split
      end

      def self.get_files(dir = '')
        Dir.entries(get_path(dir)).select { | file | File.file? get_path(dir, file) }
      end

      def self.remove(dir, file = '')
        FileUtils.rm_rf(get_path(dir, file))
      end

      def self.rename(old_name, new_name, directory = '')
        FileUtils.move(get_path(directory, old_name), get_path(directory, new_name))
      end
    end
  end
end
