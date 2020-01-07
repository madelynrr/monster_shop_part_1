require 'rails_helper'

RSpec.describe 'As a merchant admin/user' do
  before(:each) do
    @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
    @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
    @chain = @meg.items.create(name: "Chain", description: "It'll never break!", price: 50, image: "https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588", inventory: 5)
    @shifter = @meg.items.create(name: "Shimano Shifters", description: "It'll always shift!", active?: false, price: 180, image: "https://images-na.ssl-images-amazon.com/images/I/4142WWbN64L._SX466_.jpg", inventory: 2)
    
    @merchant_admin = create(:random_user, role: 2)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant_admin)
  end
  describe "When I visit my items page" do

    it "can add new items to sell in my store" do 

      visit "/merchant/items"
      
      click_on "Add New Item"
      binding.pry

      expect(current_path).to eq("/merchant/items/new")
      fill_in :name, with: new_item.name 
      binding.pry
      fill_in :price, with: price
      fill_in :description, with: description
      fill_in :image, with: image_url
      fill_in :inventory, with: inventory

      click_button "Create Item"

      new_item = Item.last
  
    end
  end
end

