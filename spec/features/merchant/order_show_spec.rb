require 'rails_helper'

RSpec.describe 'As a merchant employee/admin' do
  it 'from merchant dashboard can click order id to visit order show page' do
    merchant = create(:random_merchant)
    merchant2 = create(:random_merchant)
    merchant_employee = create(:random_user, role: 3, merchant_id: merchant.id)
    user = create(:random_user)

    item_1 = create(:random_item, merchant_id: merchant.id)
    item_2 = create(:random_item, merchant_id: merchant.id)
    item_3 = create(:random_item, merchant_id: merchant2.id)

    order = create(:random_order, user_id: user.id)
    item_1_order = ItemOrder.create!(item: item_1, order: order, price: item_1.price, quantity: 5)
    item_2_order = ItemOrder.create!(item: item_2, order: order, price: item_2.price, quantity: 3)
    item_3_order = ItemOrder.create!(item: item_3, order: order, price: item_3.price, quantity: 9)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant_employee)

    visit '/merchant'

    within "#pending-#{order.id}" do
      click_link "#{order.id}"
    end

    expect(current_path).to eq("/merchant/orders/#{order.id}")


  end
end
