admin = User.new :username => "admin", :password => "admin"
admin.is_admin = true
admin.save
