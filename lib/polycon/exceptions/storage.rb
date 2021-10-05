module Polycon
  module Exceptions
    module Storage
      class FileNotFound < StandardError
        def initialize(msg = 'El archivo no existe.')
          super(msg)
        end
      end
    end
  end
end
