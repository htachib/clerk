require 'rails_helper'

feature 'Log in user', :js => true do
  before do
    login_user(create(:user))
  end

  scenario 'Should be able to log in and view dashboard' do
    expect(page).to have_content 'Dashboard'
    expect(page).to have_content 'Documents Processed'
  end

  scenario 'Should be able to log out' do
    click_link('Log out')
    expect(page).to have_content 'Clerk is an affordable solution'
  end
end
