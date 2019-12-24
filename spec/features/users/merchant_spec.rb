require 'rails_helper'

RSpec.describe 'As a merchant' do
  it "does not allow me to access admin pages" do
    merchant = create(:random_user, role: 2)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant)

    expect(merchant.role).to eq('merchant_admin')

    visit '/admin'
    expect(page).to have_content("The page you were looking for doesn't exist (404)")
  end
end
