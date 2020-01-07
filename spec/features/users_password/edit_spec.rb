require 'rails_helper'

RSpec.describe "a user can visit their profile page" do
  it "can click a link to change their password" do
    user = create(:random_user, password: "password", password_confirmation: "password")

    visit "/login"
    fill_in :email, with: user.email
    fill_in :password, with: user.password
    click_button "Login"

    visit "/profile"

    click_link("Change Password")
    expect(current_path).to eq("/user/password/edit")

    password = "new_password"
    fill_in :password, with: password
    fill_in :password_confirmation, with: password

    click_button "Create New Password"

    expect(current_path).to eq("/profile")
    expect(page).to have_content("Your password has been updated.")

    click_link "Log Out"
    click_link "Login"
    fill_in :email, with: user.email
    fill_in :password, with: password
    click_button "Login"
    expect(current_path).to eq("/profile")
    expect(page).to have_content("Welcome, #{user.name}, you are logged in!")
  end

  it "returns error if password and password confirmation are different" do
    user = create(:random_user, password: "password", password_confirmation: "password")

    visit "/login"
    fill_in :email, with: user.email
    fill_in :password, with: user.password
    click_button "Login"

    visit "/profile"

    click_link("Change Password")
    expect(current_path).to eq("/user/password/edit")

    password = "new_password"

    fill_in :password, with: password
    fill_in :password_confirmation, with: "clam_chowder_lol"

    click_button "Create New Password"


    # expect(current_path).to eq("/user/password/edit")
    # expect(page).to have_content("")

  end
end
