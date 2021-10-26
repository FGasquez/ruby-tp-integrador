# frozen_string_literal: true

module Polycon
  module Exceptions
    module Appointment
      class NotFound < StandardError
        def initialize(msg = 'La cita no existe.')
          super(msg)
        end
      end

      class Exists < StandardError
        def initialize(msg = 'La cita ya existe.')
          super(msg)
        end
      end

      class InvalidDate < StandardError
        def initialize(msg = 'La fecha no es válida.')
          super(msg)
        end
      end
    end
  end
end
