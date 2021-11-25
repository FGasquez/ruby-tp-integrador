# frozen_string_literal: true

module Polycon
  module Commands
    module Professionals
      class Create < Dry::CLI::Command
        desc 'Create a professional'

        argument :name, required: true, desc: 'Full name of the professional'

        example [
          '"Alma Estevez"      # Creates a new professional named "Alma Estevez"',
          '"Ernesto Fernandez" # Creates a new professional named "Ernesto Fernandez"'
        ]

        def call(name:, **)
          professional = Polycon::Models::Professional.new
          professional.create(name)
          puts "El profesional #{name} se creo correctamente"
        rescue Polycon::Exceptions::Professional::Exists => e
          warn e.message
        end
      end

      class Delete < Dry::CLI::Command
        desc 'Delete a professional (only if they have no appointments)'

        argument :name, required: true, desc: 'Name of the professional'

        example [
          '"Alma Estevez"      # Deletes a new professional named "Alma Estevez" if they have no appointments',
          '"Ernesto Fernandez" # Deletes a new professional named "Ernesto Fernandez" if they have no appointments'
        ]

        def call(name: nil)
          professional = Polycon::Models::Professional.new
          professional.delete(name)
          puts 'El profesional se eliminó correctamente'
        rescue Polycon::Exceptions::Professional::NotFound,
               Polycon::Exceptions::Professional::HasAppointments => e
          warn e.message
        end
      end

      class List < Dry::CLI::Command
        desc 'List professionals'

        example [
          "          # Lists every professional's name"
        ]

        def call(*)
          professional = Polycon::Models::Professional.new
          puts professional.list
        rescue Polycon::Exceptions::Professional::NotFound => e
          warn e.message
        end
      end

      class Rename < Dry::CLI::Command
        desc 'Rename a professional'

        argument :old_name, required: true, desc: 'Current name of the professional'
        argument :new_name, required: true, desc: 'New name for the professional'

        example [
          '"Alna Esevez" "Alma Estevez" # Renames the professional "Alna Esevez" to "Alma Estevez"'
        ]

        def call(old_name:, new_name:, **)
          professional = Polycon::Models::Professional.new
          professional.rename(old_name, new_name)

          puts "El professional #{old_name} fue renombrado a #{new_name}"
        rescue Polycon::Exceptions::Professional::NotFound,
               Polycon::Exceptions::Professional::Exists => e
          warn e.message
        end
      end
    end
  end
end
