json.array!(@instructors) do |instructor|
  json.extract! instructor, :id, :first_name, :last_name, :bio, :user_id, :active, :phone
  json.url instructor_url(instructor, format: :json)
end