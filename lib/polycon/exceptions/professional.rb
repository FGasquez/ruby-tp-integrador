module Polycon
  module Exceptions
    module Professional
      class ProfessionalExists < StandardError
        def initialize(msg = 'El professional ya existe!')
          super(msg)
        end
      end

      class ProfessionalNotFound < StandardError
        def initialize(msg = 'El professional no existe.')
          super(msg)
        end
      end

      class ProfessionalHasTurnsAppointments < StandardError
        def initialize(msg = 'El professional tiene turnos.')
          super(msg)
        end
      end
      # begin
      #   raise MyError.new("my message", "my thing")
      # rescue => e
      #   puts e.thing # "my thing"
      # end
    end
  end
end
