require 'rails_helper'

RSpec.describe 'As a admin' do
  it "visit a user's profile page I see the same information the user would see" do
    admin = create(:random_user, role:1)
    user = create(:random_user, role: 0)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(admin)

    visit "/admin/users/#{user.id}"

    expect(page).to have_content("#{user.name}")
    expect(page).to have_content("#{user.address}")
    expect(page).to have_content("#{user.city}")
    expect(page).to have_content("#{user.state}")
    expect(page).to have_content("#{user.zip_code}")
    expect(page).to have_content("#{user.email}")

    expect(page).to_not have_link("Edit Profile")
  end
end
