# frozen_string_literal: true

module Polycon
  module Models
    class Professional
      def create(name)
        if Polycon::Helpers::Storage.file_exists?(name)
          raise Polycon::Exceptions::Professional::Exists, "El profesional #{name} ya existe"
        end

        Polycon::Helpers::Storage.create_dir(name)
      end

      def list
        files = Polycon::Helpers::Storage.get_files
        if files.empty?
          raise Polycon::Exceptions::Professional::NotFound, 'No hay profesionales almacenados'
        end

        files
      end

      def get(professional = nil)
        unless professional
          return list
        else
          if Polycon::Helpers::Storage.file_exists?(professional)
            return [professional]
          end
        end

        raise Polycon::Exceptions::Professional::NotFound, "El profesional #{name} no existe."
      end

      def delete(name)
        unless Polycon::Helpers::Storage.file_exists?(name)
          raise Polycon::Exceptions::Professional::NotFound, "El profesional #{name} no existe."
        end

        assigned_turns = Polycon::Helpers::Storage.get_files(name)
        unless assigned_turns.empty?
          raise Polycon::Exceptions::Professional::HasAppointments,
                "El professional #{name} no puede ser eliminado por que contiene #{assigned_turns.length} turnos asignados "
        end

        Polycon::Helpers::Storage.remove(name)
      end

      def rename(old_name, new_name)
        unless Polycon::Helpers::Storage.file_exists?(old_name)
          raise Polycon::Exceptions::Professional::NotFound, "El profesional #{old_name} no existe."
        end
        if Polycon::Helpers::Storage.file_exists?(new_name)
          raise Polycon::Exceptions::Professional::Exists, "El profesional #{new_name} ya existe."
        end

        Polycon::Helpers::Storage.rename(old_name, new_name)
      end
    end
  end
end
