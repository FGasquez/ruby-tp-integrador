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
    end
  end
end
