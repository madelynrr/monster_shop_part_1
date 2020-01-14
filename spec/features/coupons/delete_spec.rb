require 'rails_helper'

RSpec.describe "as a merchant user" do
  it "can delete a coupon from the index page" do
    merchant_1 = create(:random_merchant)
    merchant_1_admin = User.create(name: "Jordan",
                           address: "394 High St",
                           city: "Denver",
                           state: "CO",
                           zip_code: "80602",
                           email: "hotones@hotmail.com",
                           password: "password",
                           password_confirmation: "password",
                           role: 2,
                           merchant_id: merchant_1.id)

      coupon_1 = Coupon.create(name: "10% Off",
                               code: "1234",
                               percentage: 10,
                               merchant_id: merchant_1.id)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant_1_admin)

      visit "/merchant/coupons"

      within "#coupon-#{coupon_1.id}" do
        click_button "Delete Coupon"
      end

      expect(current_path).to eq("/merchant/coupons")
      expect(page).not_to have_css("#coupon-#{coupon_1.id}")
  end
end
