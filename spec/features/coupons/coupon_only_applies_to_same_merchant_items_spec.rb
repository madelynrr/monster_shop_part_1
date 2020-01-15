require 'rails_helper'

RSpec.describe "as a user" do
  it "can apply a coupon code percentage off only to items that also belong to the same merchant" do
    merchant_1 = create(:random_merchant)
    merchant_2 = create(:random_merchant)
    user = create(:random_user)
    item_1 = create(:random_item, price: 100, merchant_id: merchant_1.id)
    item_2 = create(:random_item, price: 10, merchant_id: merchant_2.id)

    coupon_1 = Coupon.create(name: "20% Off",
                             code: "1234",
                             percentage: 20,
                             merchant_id: merchant_1.id)
    visit "/"
    click_link "Login"
    fill_in :email, with: user.email
    fill_in :password, with: user.password
    click_button "Login"

    visit "/items/#{item_1.id}"
    click_button "Add To Cart"
    visit "/items/#{item_2.id}"
    click_button "Add To Cart"

    visit "/cart"

    fill_in :coupon_code, with: coupon_1.code
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

    order = Order.last
    item_order_1 = order.item_orders.first
    item_order_2 = order.item_orders.last

    expect(item_order_1.price).to eq(80.0)
    expect(item_order_2.price).to eq(10.0)


    # visit "/profile/orders/#{order.id}"
    #
    # within "#price-#{item_order_1.id}" do
    #   expect(page).to have_content("$100.00")
    # end
    #
    # within "#price-#{item_order_2.id}" do
    #   expect(page).to have_content("$10.00")
    # end
    #
    # expect(page).to have_content("Discounted Total: $90.00")
  end

  it "displays a discounted grand total on cart show page" do
    merchant_1 = create(:random_merchant)
    merchant_2 = create(:random_merchant)
    user = create(:random_user)
    item_1 = create(:random_item, price: 100, merchant_id: merchant_1.id)
    item_2 = create(:random_item, price: 10, merchant_id: merchant_2.id)

    coupon_1 = Coupon.create(name: "20% Off",
                             code: "1234",
                             percentage: 20,
                             merchant_id: merchant_1.id)
    visit "/"
    click_link "Login"
    fill_in :email, with: user.email
    fill_in :password, with: user.password
    click_button "Login"

    visit "/items/#{item_1.id}"
    click_button "Add To Cart"
    visit "/items/#{item_2.id}"
    click_button "Add To Cart"

    visit "/cart"

    fill_in :coupon_code, with: coupon_1.code
    click_button "Add Coupon To Order"

    expect(page).to have_content("Discounted Total: $90.00")
  end
end
