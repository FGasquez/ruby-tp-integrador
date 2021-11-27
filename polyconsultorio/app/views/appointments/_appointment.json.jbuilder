json.extract! appointment, :id, :name, :surname, :date, :phone, :notes, :created_at, :updated_at
json.url appointment_url(appointment, format: :json)
