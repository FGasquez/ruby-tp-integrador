# frozen_string_literal: true

require 'time'
require 'erb'

module Polycon
  module Commands
    module Appointments
      class Create < Dry::CLI::Command
        desc 'Create an appointment'

        argument :date, required: true, desc: 'Full date for the appointment'
        option :professional, required: true, desc: 'Full name of the professional'
        option :name, required: true, desc: "Patient's name"
        option :surname, required: true, desc: "Patient's surname"
        option :phone, required: true, desc: "Patient's phone number"
        option :notes, required: false, desc: 'Additional notes for appointment'

        example [
          '"2021-09-16 13:00" --professional="Alma Estevez" --name=Carlos --surname=Carlosi --phone=2213334567'
        ]

        def call(date:, professional:, name:, surname:, phone:, notes: nil)
          appointment = Polycon::Models::Appointment.new
          appointment.create(date, professional, name, surname, phone, notes)
          puts "La cita con el professional #{professional} en la fecha #{date} se creó correctamente"
        rescue Polycon::Exceptions::Professional::NotFound,
               Polycon::Exceptions::Appointment::InvalidDate,
               Polycon::Exceptions::Appointment::Exists => e
          warn e.message
        end
      end

      class Show < Dry::CLI::Command
        desc 'Show details for an appointment'

        argument :date, required: true, desc: 'Full date for the appointment'
        option :professional, required: true, desc: 'Full name of the professional'

        example [
          '"2021-09-16 13:00" --professional="Alma Estevez" # Shows information for the appointment with Alma Estevez on the specified date and time'
        ]

        def call(date:, professional:)
          keys_es = {
            'name': 'Nombre',
            'surname': 'Apellido',
            'notes': 'Notas',
            'phone': 'Telefono',
            'professional': 'Profesional',
            'date': 'Fecha'
          }

          appointment = Polycon::Models::Appointment.new
          appointment.get_data(date, professional).map { |k, v| puts "#{keys_es[k]}: #{v}" if v }
        rescue Polycon::Exceptions::Professional::NotFound,
               Polycon::Exceptions::Appointment::NotFound => e
          warn e.message
        end
      end

      class Cancel < Dry::CLI::Command
        desc 'Cancel an appointment'

        argument :date, required: true, desc: 'Full date for the appointment'
        option :professional, required: true, desc: 'Full name of the professional'

        example [
          '"2021-09-16 13:00" --professional="Alma Estevez" # Cancels the appointment with Alma Estevez on the specified date and time'
        ]

        def call(date:, professional:)
          appointment = Polycon::Models::Appointment.new
          appointment.cancel(date, professional)
          puts "La cita con el professional #{professional} en la fecha #{date} se eliminó correctamente"
        rescue Polycon::Exceptions::Professional::NotFound,
               Polycon::Exceptions::Appointment::NotFound => e
          warn e.message
        end
      end

      class CancelAll < Dry::CLI::Command
        desc 'Cancel all appointments for a professional'

        argument :professional, required: true, desc: 'Full name of the professional'

        example [
          '"Alma Estevez" # Cancels all appointments for professional Alma Estevez'
        ]

        def call(professional:)
          appointment = Polycon::Models::Appointment.new
          appointment.cancel_all(professional).each do |appointment|
            puts " - #{File.basename(appointment, '.paf')}"
          end
          puts "Fueron eliminados para el professional #{professional}"
        rescue Polycon::Exceptions::Professional::NotFound,
               Polycon::Exceptions::Appointment::NotFound => e
          warn e.message
        end
      end

      class List < Dry::CLI::Command
        desc 'List appointments for a professional, optionally filtered by a date'

        argument :professional, required: true, desc: 'Full name of the professional'
        option :date, required: false, desc: 'Date to filter appointments by (should be the day)'

        example [
          '"Alma Estevez" # Lists all appointments for Alma Estevez',
          '"Alma Estevez" --date="2021-09-16" # Lists appointments for Alma Estevez on the specified date'
        ]

        def call(professional:)
          appointment = Polycon::Models::Appointment.new
          appointments = appointment.get_all_appointments(professional)
          puts "El professional #{professional} no tiene citas registradas" if appointments.empty?
          appointments.each { |appointment| puts " - #{File.basename(appointment, '.paf')}" }
        rescue Polycon::Exceptions::Professional::NotFound => e
          warn e.message
        end
      end

      class Reschedule < Dry::CLI::Command
        desc 'Reschedule an appointment'

        argument :old_date, required: true, desc: 'Current date of the appointment'
        argument :new_date, required: true, desc: 'New date for the appointment'
        option :professional, required: true, desc: 'Full name of the professional'

        example [
          '"2021-09-16 13:00" "2021-09-16 14:00" --professional="Alma Estevez" # Reschedules appointment on the first date for professional Alma Estevez to be now on the second date provided'
        ]

        def call(old_date:, new_date:, professional:)
          appointment = Polycon::Models::Appointment.new
          appointment.rescedule(old_date, new_date, professional)
          puts "La cita del #{old_date} fue reasignada a #{new_date}"
        rescue Polycon::Exceptions::Professional::NotFound,
               Polycon::Exceptions::Appointment::NotFound,
               Polycon::Exceptions::Appointment::Exists,
               Polycon::Exceptions::Appointment::InvalidDate => e
          warn e.message
        end
      end

      # export command
      class Export < Dry::CLI::Command
        desc 'Edit information for an appointments'

        argument :date, required: true, desc: 'Day for the appointments'
        option :professional, required: false, desc: 'Full name of the professional'
        option :week, type: :boolean, required: false, desc: 'Get all week'

        example [
          '"2021-11-15"',
          '"2021-11-15" --week',
          '"2021-11-15" --professiona="Alma Estevez"',
          '"2021-11-15" --professiona="Alma Estevez" --week',
        ]

        def call(professional: nil, date: nil, week: nil)
          end_date = nil
          initial_date = Date.parse(date)
          appointment = Polycon::Models::Appointment.new
          professional_model = Polycon::Models::Professional.new

          days = ["Domingo", "Lunes", "Martes", "Miércoles", "Jueves", "Viernes", "Sábado"]
          if week.equal?(true)
            initial_date = Date.parse(date) - Date.parse(date).wday
            end_date = initial_date + 6
          end
          puts professional
          appointments = appointment.get_from_all_professionals(
            professional_model.get(professional), initial_date, end_date
          )

          Polycon::Helpers::Storage.write_with_template("export.html.erb", "export.html",
                                                        { appointments: appointments, first_day: Date.parse(date) - Date.parse(date).wday, days: days })
          puts "Se generó el archivo export.html"
        rescue Polycon::Exceptions::Professional::NotFound,
               Polycon::Exceptions::Appointment::NotFound => e
          warn e.message
        end
      end

      class Edit < Dry::CLI::Command
        desc 'Edit information for an appointments'

        argument :date, required: true, desc: 'Full date for the appointment'
        option :professional, required: true, desc: 'Full name of the professional'
        option :name, required: false, desc: "Patient's name"
        option :surname, required: false, desc: "Patient's surname"
        option :phone, required: false, desc: "Patient's phone number"
        option :notes, required: false, desc: 'Additional notes for appointment'

        example [
          '"2021-09-16 13:00" --professional="Alma Estevez" --name="New name" # Only changes the patient\'s name for the specified appointment. The rest of the information remains unchanged.',
          '"2021-09-16 13:00" --professional="Alma Estevez" --name="New name" --surname="New surname" # Changes the patient\'s name and surname for the specified appointment. The rest of the information remains unchanged.',
          '"2021-09-16 13:00" --professional="Alma Estevez" --notes="Some notes for the appointment" # Only changes the notes for the specified appointment. The rest of the information remains unchanged.'
        ]

        def call(date:, professional:, **options)
          appointment = Polycon::Models::Appointment.new
          appointment.edit(date, professional, options)
          puts 'La cita fue modificada con exito'
        rescue Polycon::Exceptions::Professional::NotFound,
               Polycon::Exceptions::Appointment::NotFound => e
          warn e.message
        end
      end
    end
  end
end
