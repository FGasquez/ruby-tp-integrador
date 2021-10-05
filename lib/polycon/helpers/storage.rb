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

      def self.create_file(file)
        FileUtils.touch(get_path(file))
      end

      def self.get_files(dir = '')
        Dir.entries(get_path(dir))[2..]
      end

      def self.remove(file)
        FileUtils.rm_rf(get_path(file))
      end

      def self.rename(old_name, new_name)
        FileUtils.move(get_path(old_name), get_path(new_name))
      end
    end
  end
end
