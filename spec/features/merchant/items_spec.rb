require 'rails_helper'

RSpec.describe 'As a merchant' do
  describe 'When I am on the items page' do
    before :each do
      @merchant = create(:random_merchant)
      @item_1 = create(:random_item, merchant_id: @merchant.id)
      @item_2 = create(:random_item, merchant_id: @merchant.id)
      @user = create(:random_user)
      @order = create(:random_order, user_id: @user.id)
      @item_1_order = ItemOrder.create!(item: @item_1, order: @order, price: @item_1.price, quantity: 5, status: 1)
      @merchant_user = create(:random_user, role: 3, merchant_id: @merchant.id)
    end

    it "Has a button to delete each item that has never been ordered" do

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant_user)

      visit "/merchant/items"

      within "#item-#{@item_1.id}" do
        expect(page).not_to have_link("Delete Item")
      end

      within "#item-#{@item_2.id}" do
        expect(page).to have_link("Delete Item")
      end
    end

    it "can delete the item and show a flash message" do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant_user)

      visit "/merchant/items"

      within "#item-#{@item_2.id}" do
        click_link "Delete Item"
      end

      @merchant.reload

      expect(current_path).to eq("/merchant/items")
      expect(page).to have_content("You deleted #{@item_2.name}")
      expect(page).to_not have_css("#item-#{@item_2.id}")
    end

    it "can edit each item" do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant_user)

      visit "/merchant/items"

      original_name = @item_1.name

      within "#item-#{@item_1.id}" do
        click_link 'Edit Item'
      end

      expect(current_path).to eq("/merchant/items/#{@item_1.id}/edit")
      expect(find_field("Name").value).to eq(original_name)
      expect(find_field("Description").value).to eq(@item_1.description)
      expect(find_field("Price").value).to eq("#{@item_1.price}")
      expect(find_field("Image").value).to eq(@item_1.image)
      expect(find_field("Inventory").value).to eq("#{@item_1.inventory}")

      fill_in "Name", with: ""
      click_button "Update Item"

      expect(page).to have_content("Name can't be blank")
      fill_in "Name", with: "Wheel"
      click_button "Update Item"

      expect(current_path).to eq("/merchant/items")
      expect(page).to have_content("Your item has been updated")

      within "#item-#{@item_1.id}" do
        expect(page).to_not have_content(original_name)
        expect(page).to have_content("Wheel")
      end
    end

    it "cannot edit an item if details are bad/missing" do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant_user)

      visit "/merchant/items/#{@item_1.id}/edit"

      fill_in "Name", with: ""
      fill_in "Description", with: "Fancy thing"
      fill_in 'Price', with: 12
      fill_in 'Image', with: ""
      fill_in 'Inventory', with: 11

      click_button "Update Item"

      expect(page).to have_content("Name can't be blank")

    end
  end
end
