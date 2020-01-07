require 'rails_helper'

RSpec.describe 'merchant show page', type: :feature do
  describe 'As a user' do
    before :each do
      @bike_shop = Merchant.create(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Richmond', state: 'VA', zip: 23137)
    end

    it 'I can see a merchants name, address, city, state, zip' do
      visit "/merchants/#{@bike_shop.id}"

      expect(page).to have_content("Brian's Bike Shop")
      expect(page).to have_content("123 Bike Rd.\nRichmond, VA 23137")
    end

    it 'I can see a link to visit the merchant items' do
      visit "/merchants/#{@bike_shop.id}"

      expect(page).to have_link("All #{@bike_shop.name} Items")

      click_on "All #{@bike_shop.name} Items"

      expect(current_path).to eq("/merchants/#{@bike_shop.id}/items")
    end

    it 'displays that merchants items' do
      merchant_user = create(:random_user, merchant_id: @bike_shop.id, role: 3)
      merchant = create(:random_merchant)

      item_1 = create(:random_item, merchant_id: @bike_shop.id)
      item_2 = create(:random_item, merchant_id: @bike_shop.id)
      item_3 = create(:random_item, merchant_id: merchant.id)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant_user)

      visit "/merchant/items"
      save_and_open_page
      within "#item-#{item_1.id}" do
        expect(page).to have_content(item_1.name)
        expect(page).to have_content(item_1.description)
        expect(page).to have_content(item_1.price)
        expect(page).to have_content("Active")
        expect(page).to have_content(item_1.inventory)
        expect(page).to have_css("img[src*='#{item_1.image}']")
      end

      within "#item-#{item_2.id}" do
        expect(page).to have_content(item_2.name)
        expect(page).to have_content(item_2.description)
        expect(page).to have_content(item_2.price)
        expect(page).to have_content("Active")
        expect(page).to have_content(item_2.inventory)
        expect(page).to have_css("img[src*='#{item_2.image}']")
      end

      expect(page).to_not have_css("#item-#{item_3.id}")
    end

    it 'has button to deactive an item next to each item' do

      merchant_user = create(:random_user, merchant_id: @bike_shop.id, role: 3)

      item_1 = create(:random_item, merchant_id: @bike_shop.id)
      item_2 = create(:random_item, merchant_id: @bike_shop.id)
      item_3 = create(:random_item, merchant_id: @bike_shop.id, active?: false)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant_user)

      within "#item-#{item_1.id}" do
        expect(page).to have_button("Deactivate")
      end

      within "#item-#{item_3.id}" do
        expect(page).to_not have_button("Deactivate")
      end

      within "#item-#{item_2.id}" do
        click_button("Deactivate")
      end

      expect(current_path).to eq("/merchant/items")
      expect(page).to have_content("#{item_2.name} is deactivated")

      within "#item-#{item_1.id}" do
        expect(page).to have_content("Active")
      end

      within "#item-#{item_2.id}" do
        expect(page).to have_content("Inactive")
      end

      within "#item-#{item_3.id}" do
        expect(page).to have_content("Inactive")
      end

    end

  end
end
