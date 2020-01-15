require 'rails_helper'

RSpec.describe "as a visitor" do
  it "can add a coupon to order" do
    merchant = create(:random_merchant)
    item = create(:random_item, merchant_id: merchant.id)
    coupon_1 = Coupon.create(name: "10% Off",
                             code: "1234",
                             percentage: 10,
                             merchant_id: merchant.id)

    visit "/items/#{item.id}"
    click_button "Add To Cart"
    visit "/cart"

    fill_in :coupon_code, with: coupon_1.code

    click_button "Add Coupon To Order"

    expect(current_path).to eq("/cart")

    visit "/items"
    visit "/cart"

    expect(find_field("Coupon Code").value).to eq(coupon_1.code)
  end
end
