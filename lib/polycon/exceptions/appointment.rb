# frozen_string_literal: true

module Polycon
  module Exceptions
    module Appointment
      class AppointmentNotFound < StandardError
        def initialize(msg = 'La cita no existe.')
          super(msg)
        end
      end

      class AppointmentExists < StandardError
        def initialize(msg = 'La cita ya existe.')
          super(msg)
        end
      end

      class AppointmentInvalidDate < StandardError
        def initialize(msg = 'La fecha no es válida.')
          super(msg)
        end
      end
    end
  end
end
