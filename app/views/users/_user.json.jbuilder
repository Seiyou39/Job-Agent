json.extract! user, :id, :email_address, :role, :created_at, :updated_at
json.url user_url(user, format: :json)
