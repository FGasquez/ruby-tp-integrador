# frozen_string_literal: true

require 'time'

module Polycon
  module Commands
    module Reports
      class DailyReport < Dry::CLI::Command
        desc 'Create a daily report'

        argument :date, required: true, desc: 'Full date for the appointment'
        option :professional, required: true, desc: 'Full name of the professional'

        example [
          '"2021-09-16 13:00" --professional="Alma Estevez"'
        ]

        def call(date:, professional: nil)
          Polycon::Models::Appointment.get(date, professional)
          puts "La cita con el professional #{professional} en la fecha #{date} se creó correctamente"
        rescue Polycon::Exceptions::Professional::NotFound,
               Polycon::Exceptions::Appointment::InvalidDate,
               Polycon::Exceptions::Appointment::Exists => e
          warn e.message
        end
      end
    end
  end
end
