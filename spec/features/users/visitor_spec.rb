require 'rails_helper'

RSpec.describe "As a visitor", type: :feature do
  it "does not allow me to go to pages I am not authorized for" do
    visit '/admin'
    expect(page).to have_content("The page you were looking for doesn't exist (404)")

    visit '/merchant'
    expect(page).to have_content("The page you were looking for doesn't exist (404)")

    visit '/profile'
    expect(page).to have_content("The page you were looking for doesn't exist (404)")
  end
end