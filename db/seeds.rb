admin_params = { email: 'admin@clerkocr.com' }
admin = User.find_by(admin_params)
User.create!(admin_params.merge('password' => 'password', 'password_confirmation' => 'password')) if admin.nil?
