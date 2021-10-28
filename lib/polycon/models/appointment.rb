# frozen_string_literal: true
module Polycon
  module Models
    class Appointment
      def self.create(date, professional, name, surname, phone, notes = nil)
        unless Polycon::Helpers::Storage.file_exists?(professional)
          raise Polycon::Exceptions::Professional::NotFound, "El profesional #{professional} no existe."
        end

        if Time.parse("#{date}+03:00") < Time.now
          raise Polycon::Exceptions::Appointment::InvalidDate, "La fecha \"#{date}\" no es válida"
        end

        if Polycon::Helpers::Storage.file_exists?(professional, "#{date}.paf")
          raise Polycon::Exceptions::Appointment::Exists,
                "Ya hay una cita para el profesional #{professional} en la fecha #{date}."
        end

        Polycon::Helpers::Storage.write(professional, date, name, surname, phone, notes)
      end

      def self.get_data(date, professional)
        unless Polycon::Helpers::Storage.file_exists?(professional)
          raise Polycon::Exceptions::Professional::NotFound, "El profesional #{professional} no existe."
        end

        unless Polycon::Helpers::Storage.file_exists?(professional, "#{date}.paf")
          raise Polycon::Exceptions::Appointment::NotFound,
                "No existe la cita para el profesional #{professional} en la fecha #{date}."
        end

        content = Polycon::Helpers::Storage.read_file(professional, date)
        {
          name: content[0],
          surname: content[1],
          phone: content[2],
          notes: content[3],
          date: date,
          professional: professional,
        }
      end

      def self.cancel(date, professional)
        unless Polycon::Helpers::Storage.file_exists?(professional)
          raise Polycon::Exceptions::Professional::NotFound, "El profesional #{professional} no existe."
        end

        unless Polycon::Helpers::Storage.file_exists?(professional, "#{date}.paf")
          raise Polycon::Exceptions::Appointment::NotFound,
                "No existe la cita para el profesional #{professional} en la fecha #{date}."
        end

        Polycon::Helpers::Storage.remove(professional, "#{date}.paf")
      end

      def self.cancel_all(professional)
        if get_all_appointments(professional).empty?
          raise Polycon::Exceptions::Appointment::NotFound,
                "El professional #{professional} no contiene citas asignadas"
        end
        get_all_appointments(professional).each do |appointment|
          Polycon::Helpers::Storage.remove(professional, appointment)
        end
      end

      def self.get_all_appointments(professional)
        unless Polycon::Helpers::Storage.file_exists?(professional)
          raise Polycon::Exceptions::Professional::NotFound, "El profesional #{professional} no existe."
        end

        Polycon::Helpers::Storage.get_files(professional)
      end

      def self.rescedule(date, new_date, professional)
        unless Polycon::Helpers::Storage.file_exists?(professional)
          raise Polycon::Exceptions::Professional::NotFound, "El profesional #{professional} no existe."
        end

        if Time.parse("#{new_date}+03:00") < Time.now
          raise Polycon::Exceptions::Appointment::InvalidDate, "La fecha \"#{date}\" no es válida"
        end

        unless Polycon::Helpers::Storage.file_exists?(professional, "#{date}.paf")
          raise Polycon::Exceptions::Appointment::NotFound,
                "No existe la cita para el profesional #{professional} en la fecha #{date}."
        end
        if Polycon::Helpers::Storage.file_exists?(professional, "#{new_date}.paf")
          raise Polycon::Exceptions::Appointment::Exists,
                "Ya hay una cita para el profesional #{professional} en la fecha #{new_date}."
        end

        Polycon::Helpers::Storage.rename("#{date}.paf", "#{new_date}.paf", professional)
      end

      def self.edit(date, professional, **args)
        new_values = get_data(date, professional).merge(args)
        Polycon::Helpers::Storage.write(professional, date, *new_values.values)
      end

      # export appointments to html using erb
      def self.get_filtered_appointments(professional, initial_date, final_date = nil)
        unless Polycon::Helpers::Storage.file_exists?(professional)
          raise Polycon::Exceptions::Professional::NotFound, "El profesional #{professional} no existe."
        end

        appointments = get_all_appointments(professional).select do |appointment|
          Date.parse(File.basename(appointment, '.paf')).between?(initial_date, final_date || initial_date)
        end
        appointments.map do 
          |appointment| get_data(File.basename(appointment, '.paf'), professional)
        end
      end

      def self.get_from_all_professionals(professionals, initial_date, final_date)
        appointments = []
        professionals.each do |professional|
          appointments.concat(get_filtered_appointments(professional, initial_date, final_date))
        end
        appointments = appointments.group_by { |appointment| Date.parse(appointment[:date]).to_date.to_s }
        puts appointments.to_s
      end      
    end
  end
end