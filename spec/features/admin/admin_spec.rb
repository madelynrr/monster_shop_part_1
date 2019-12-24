require 'rails_helper'

RSpec.describe 'As an Admin' do
  it 'can not allow me to go to merchant page or cart' do

    admin = create(:random_user, role:1)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(admin)

    expect(admin.role).to eq("admin")

    visit '/merchant'
    expect(page).to have_content("The page you were looking for doesn't exist (404)")

    visit '/cart'
    expect(page).to have_content("The page you were looking for doesn't exist (404)")

  end
end
