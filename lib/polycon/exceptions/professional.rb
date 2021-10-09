# frozen_string_literal: true

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

      class ProfessionalHasAppointments < StandardError
        def initialize(msg = 'El professional tiene turnos.')
          super(msg)
        end
      end
    end
  end
end
