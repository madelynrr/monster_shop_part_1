require 'rails_helper'

RSpec.describe "as a merchant user" do
  it "can edit a coupon from the coupon show page" do
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

      visit "/merchant/coupons/#{coupon_1.id}"

      click_button "Edit Coupon"

      expect(current_path).to eq("/merchant/coupons/#{coupon_1.id}/edit")

      expect(find_field("Name").value).to eq(coupon_1.name)
      expect(find_field("Code").value).to eq(coupon_1.code)
      expect(find_field("Percentage").value).to eq(coupon_1.percentage.to_s)

      name = "20% Off"
      code = "2345"
      percentage = 20

      fill_in :name, with: name
      fill_in :code, with: code
      fill_in :percentage, with: percentage

      click_button "Update Coupon"

      updated_coupon = Coupon.last

      expect(current_path).to eq("/merchant/coupons/#{coupon_1.id}")
      expect(page).to have_content(updated_coupon.name)
      expect(page).to have_content(updated_coupon.code)
      expect(page).to have_content(updated_coupon.percentage)
  end
end
