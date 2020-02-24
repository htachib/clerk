def submit_login_form(user)
  fill_in 'user_email', with: user.email
  fill_in 'user_password', with: 'password'
  click_button 'Log in'
end

def login_user(user)
  visit login_path
  submit_login_form(user)
end
