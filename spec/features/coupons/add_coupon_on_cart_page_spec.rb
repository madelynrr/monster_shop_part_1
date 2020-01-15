require 'rails_helper'

RSpec.describe "as a visitor" do
  it "can add a coupon to order" do
    merchant = create(:random_merchant)
    item_1 = create(:random_item, merchant_id: merchant.id)
    item_2 = create(:random_item, merchant_id: merchant.id)
    coupon_1 = Coupon.create(name: "10% Off",
                             code: "1234",
                             percentage: 10,
                             merchant_id: merchant.id)

    visit "/items/#{item_1.id}"
    click_button "Add To Cart"

    visit "/cart"

    fill_in :coupon_code, with: coupon_1.code

    click_button "Add Coupon To Order"

    expect(current_path).to eq("/cart")

    visit "/items/#{item_2.id}"
    click_button "Add To Cart"

    visit "/cart"

    expect(find_field("Coupon code").value).to eq(coupon_1.code)
  end

  it "show error message if coupon code not in system" do
    merchant = create(:random_merchant)
    item = create(:random_item, merchant_id: merchant.id)

    visit "/items/#{item.id}"
    click_button "Add To Cart"
    visit "/cart"

    coupon_code = 1234

    fill_in :coupon_code, with: coupon_code

    click_button "Add Coupon To Order"

    expect(current_path).to eq("/cart")
    expect(page).to have_content("#{coupon_code} is not a valid coupon code.")
  end
end
