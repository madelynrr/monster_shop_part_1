require 'rails_helper'

RSpec.describe 'As an Admin' do
  before :each do
    @admin = create(:random_user, role:1)
    @merchant_1 = create(:random_merchant)
    @merchant_2 = create(:random_merchant)
  end

  it "can all merchants in the system" do

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@admin)

    visit "/admin/merchants"

    expect(page).to have_link(@merchant_1.name)
    expect(page).to have_link(@merchant_2.name)

    within "#merchant-#{@merchant_1.id}" do
      expect(page).to have_content(@merchant_1.city)
      expect(page).to have_content(@merchant_1.state)
      expect(page).to have_button('Disable Merchant')
    end

    within "#merchant-#{@merchant_2.id}" do
      expect(page).to have_content(@merchant_2.city)
      expect(page).to have_content(@merchant_2.state)
      click_button('Disable Merchant')
      expect(page).to_not have_button('Disable Merchant')
      expect(page).to have_button('Enable Merchant')
    end
  end
    it "merchants link directs to merchants show page." do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@admin)

      visit "/admin/merchants"

      click_link @merchant_1.name

      expect(current_path).to eq("/admin/merchants/#{@merchant_1.id}")
    end
  end
