User.create! do |u|
  u.username = "admin"
  u.password = u.password_confirmation = "admin"
end
