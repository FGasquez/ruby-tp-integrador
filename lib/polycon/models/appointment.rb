module Polycon
  module Models
    class Appointment
      def self.create(date, professional, name, surname, phone, notes=nil)
        unless Polycon::Helpers::Storage.file_exists?(professional)
          raise Polycon::Exceptions::Professional::ProfessionalNotFound, "El profesional #{professional} no existe."
        end

        # TODO validar fecha
        # if DateTime.parse("#{date}+03:00") < DateTime.now
        #   raise Exceptions::Time::Error, "La fecha #{date} no es válida"
        # end

        if Polycon::Helpers::Storage.file_exists?(professional, "#{date}.paf")
          raise Polycon::Exceptions::Appointment::AppointmentExists, "Ya hay una cita para el profesional #{professional} en la fecha #{date}."
        end
        Polycon::Helpers::Storage.create_file(professional, date, name, surname, phone, notes)
      end

      def self.get_data(date, professional)
        unless Polycon::Helpers::Storage.file_exists?(professional)
          raise Polycon::Exceptions::Professional::ProfessionalNotFound, "El profesional #{professional} no existe."
        end
        unless Polycon::Helpers::Storage.file_exists?(professional, "#{date}.paf")
          raise Polycon::Exceptions::Appointment::AppointmentNotFound, "No existe la cita para el profesional #{professional} en la fecha #{date}."
        end
        Polycon::Helpers::Storage.read_file(professional, date)
      end
    end
  end
end