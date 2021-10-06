module Polycon
  module Models
    class Professional
      def self.create(name)
        if Polycon::Helpers::Storage.file_exists?(name)
          raise Polycon::Exceptions::Professional::ProfessionalExists, "El profesional #{name} ya existe"
        end

        Polycon::Helpers::Storage.create_dir(name)
      end

      def self.list
        Polycon::Helpers::Storage.create_dir unless Polycon::Helpers::Storage.file_exists?

        files = Polycon::Helpers::Storage.get_files
        if files.empty?
          raise Polycon::Exceptions::Professional::ProfessionalNotFound, 'No hay profesionales almacenados'
        end

        files
      end

      def self.delete(name)
        unless Polycon::Helpers::Storage.file_exists?(name)
          raise Polycon::Exceptions::Professional::ProfessionalNotFound, "El profesional #{name} no existe."
        end

        assigned_turns = Polycon::Helpers::Storage.get_files(name)
        unless assigned_turns.empty?
          raise Polycon::Exceptions::Professional::ProfessionalHasTurnsAppointments,
                "El professional #{name} no puede ser eliminado por que contiene #{assigned_turns.length} turnos asignados "
        end

        Polycon::Helpers::Storage.remove(name)
      end

      def self.rename(old_name, new_name)
        unless Polycon::Helpers::Storage.file_exists?(old_name)
          raise Polycon::Exceptions::Professional::ProfessionalNotFound, "El profesional #{old_name} no existe."
        end
        if Polycon::Helpers::Storage.file_exists?(new_name)
          raise Polycon::Exceptions::Professional::ProfessionalExists, "El profesional #{new_name} ya existe."
        end

        Polycon::Helpers::Storage.rename(old_name, new_name)
      end
    end
  end
end
