json.extract! reservation, :id, :facility_id, :user_name, :user_email, :start_time, :end_time, :purpose, :status, :created_at, :updated_at
json.url reservation_url(reservation, format: :json)
