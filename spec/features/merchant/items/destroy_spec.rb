require 'rails_helper'

RSpec.describe 'As a merchant' do
  before :each do
    @merchant = create(:random_merchant)
    @item_1 = create(:random_item, merchant_id: @merchant.id)
    @item_2 = create(:random_item, merchant_id: @merchant.id)
    @user = create(:random_user)
    @order = create(:random_order, user_id: @user.id)
    @item_1_order = ItemOrder.create!(item: @item_1, order: @order, price: @item_1.price, quantity: 5, status: 1)
    @merchant_user = create(:random_user, role: 3, merchant_id: @merchant.id)
    @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
    @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
    @chain = @meg.items.create(name: "Chain", description: "It'll never break!", price: 50, image: "https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588", inventory: 5)
    @shifter = @meg.items.create(name: "Shimano Shifters", description: "It'll always shift!", active?: false, price: 180, image: "https://images-na.ssl-images-amazon.com/images/I/4142WWbN64L._SX466_.jpg", inventory: 2)
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
end
