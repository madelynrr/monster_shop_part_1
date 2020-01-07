require 'rails_helper'

RSpec.describe 'As a merchant' do
  describe 'When I am on the items page' do
    it "Has a button to delete each item that has never been ordered" do
      merchant = create(:random_merchant)
      item_1 = create(:random_item, merchant_id: merchant.id)
      item_2 = create(:random_item, merchant_id: merchant.id)
      user = create(:random_user)
      order = create(:random_order, user_id: user.id)
      item_1_order = Item_Order.create!(item: item_1, order: order, price: item_1.price, quantity: 5, status: 1)
      merchant_user = create(:random_user, role: 3)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant_user)

      visit "/merchant/items"

      
    end
  end
end
