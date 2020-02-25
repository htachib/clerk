require 'rails_helper'

feature 'Root page', :js => true do
  scenario 'Root page should be working' do
    visit root_path
    expect(page).to have_text 'Fire your data entry team'
  end
end
