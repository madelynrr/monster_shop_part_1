require 'rails_helper'

RSpec.describe "as a logged in user" do
  it "applies last entered coupon code to order at checkout" do
    merchant = create(:random_merchant)
    user = create(:random_user)
    item_1 = create(:random_item, price: 100, merchant_id: merchant.id)
    coupon_1 = Coupon.create(name: "20% Off",
                             code: "1234",
                             percentage: 20,
                             merchant_id: merchant.id)
    coupon_2 = Coupon.create(name: "30% Off",
                             code: "2345",
                             percentage: 30,
                             merchant_id: merchant.id)
    visit "/"
    click_link "Login"
    fill_in :email, with: user.email
    fill_in :password, with: user.password
    click_button "Login"

    visit "/items/#{item_1.id}"
    click_button "Add To Cart"

    visit "/cart"

    fill_in :coupon_code, with: coupon_1.code
    click_button "Add Coupon To Order"

    fill_in :coupon_code, with: coupon_2.code
    click_button "Add Coupon To Order"

    click_link "Checkout"

    name = user.name
    address = user.address
    city = user.city
    state = user.state
    zip_code = user.zip_code

    fill_in :name, with: name
    fill_in :address, with: address
    fill_in :city, with: city
    fill_in :state, with: state
    fill_in :zip, with: zip_code

    click_button "Create Order"

    expect(current_path).to eq("/profile/orders")

    order = Order.last

    expect(order.coupon_id).to eq(coupon_2.id)
  end
end
