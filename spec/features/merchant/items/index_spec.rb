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
      @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      @chain = @meg.items.create(name: "Chain", description: "It'll never break!", price: 50, image: "https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588", inventory: 5)
      @shifter = @meg.items.create(name: "Shimano Shifters", description: "It'll always shift!", active?: false, price: 180, image: "https://images-na.ssl-images-amazon.com/images/I/4142WWbN64L._SX466_.jpg", inventory: 2)
    end

      it 'shows me a list of that merchants items' do
        visit "merchants/#{@meg.id}/items"

        within "#item-#{@tire.id}" do
          expect(page).to have_content(@tire.name)
          expect(page).to have_content("Price: $#{@tire.price}")
          expect(page).to have_css("img[src*='#{@tire.image}']")
          expect(page).to have_content("Active")
          expect(page).to_not have_content(@tire.description)
          expect(page).to have_content("Inventory: #{@tire.inventory}")
        end

        within "#item-#{@chain.id}" do
          expect(page).to have_content(@chain.name)
          expect(page).to have_content("Price: $#{@chain.price}")
          expect(page).to have_css("img[src*='#{@chain.image}']")
          expect(page).to have_content("Active")
          expect(page).to_not have_content(@chain.description)
          expect(page).to have_content("Inventory: #{@chain.inventory}")
        end

        expect(page).not_to have_css("#item-#{@shifter.id}")
    end

  end
end
