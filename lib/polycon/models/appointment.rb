module Polycon
  module Models
    class Appointment
      def self.create(date, professional, name, surname, phone, notes=nil)
        unless Polycon::Helpers::Storage.file_exists?(professional)
          raise Polycon::Exceptions::Professional::ProfessionalNotFound, "El profesional #{professional} no existe."
        end

        # TODO validar fecha
        # if Time.parse("#{date}+03:00") < Time.now
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
        content = Polycon::Helpers::Storage.read_file(professional, date)
        return {
          Professional: professional,
          Fecha: date,
          Paciente: "#{content[0]} #{content[1]}",
          Telefono: content[2],
          Notas: content[3]
        }
      end

      def self.cancel(date, professional)
        unless Polycon::Helpers::Storage.file_exists?(professional)
          raise Polycon::Exceptions::Professional::ProfessionalNotFound, "El profesional #{professional} no existe."
        end
        unless Polycon::Helpers::Storage.file_exists?(professional, "#{date}.paf")
          raise Polycon::Exceptions::Appointment::AppointmentNotFound, "No existe la cita para el profesional #{professional} en la fecha #{date}."
        end
        Polycon::Helpers::Storage.remove(professional, "#{date}.paf")
      end

      def self.cancel_all(professional)
        unless Polycon::Helpers::Storage.file_exists?(professional)
          raise Polycon::Exceptions::Professional::ProfessionalNotFound, "El profesional #{professional} no existe."
        end
        
        if get_all_appointments(professional).empty?
          raise Polycon::Exceptions::Professional::AppointmentNotFound,
                "El professional #{professional} no contiene citas asignadas"
        end
        get_all_appointments(professional).each { | appointment | Polycon::Helpers::Storage.remove(professional, appointment) }
      end
      
      def self.get_all_appointments(professional)
        unless Polycon::Helpers::Storage.file_exists?(professional)
          raise Polycon::Exceptions::Professional::ProfessionalNotFound, "El profesional #{professional} no existe."
        end

        Polycon::Helpers::Storage.get_files(professional)
      end

      def self.rescedule(date, new_date, professional)
        unless Polycon::Helpers::Storage.file_exists?(professional)
          raise Polycon::Exceptions::Professional::ProfessionalNotFound, "El profesional #{professional} no existe."
        end
        unless Polycon::Helpers::Storage.file_exists?(professional, "#{date}.paf")
          raise Polycon::Exceptions::Appointment::AppointmentNotFound, "No existe la cita para el profesional #{professional} en la fecha #{date}."
        end
        if Polycon::Helpers::Storage.file_exists?(professional, "#{new_date}.paf")
          raise Polycon::Exceptions::Appointment::AppointmentExists, "Ya hay una cita para el profesional #{professional} en la fecha #{new_date}."
        end
        Polycon::Helpers::Storage.rename("#{date}.paf", "#{new_date}.paf", directory=professional)
      end
    end
  end
end