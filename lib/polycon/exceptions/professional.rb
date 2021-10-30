# frozen_string_literal: true

module Polycon
  module Exceptions
    module Professional
      class Exists < StandardError
        def initialize(msg = 'El professional ya existe!')
          super(msg)
        end
      end

      class NotFound < StandardError
        def initialize(msg = 'El professional no existe.')
          super(msg)
        end
      end

      class HasAppointments < StandardError
        def initialize(msg = 'El professional tiene turnos.')
          super(msg)
        end
      end
    end
  end
end
