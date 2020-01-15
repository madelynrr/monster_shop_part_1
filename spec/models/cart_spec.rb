require 'rails_helper'

RSpec.describe Cart, type: :model do
  describe "methods" do
    it ".discounted_total" do
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

      fill_in :coupon_code, with: coupon_1.code
      click_button "Add Coupon To Order"

      expect(cart.discounted_total).to eq(90)
    end
  end
end
