require 'rails_helper'

RSpec.describe "as a merchant user" do
  it "can add a coupon from the coupon index page" do
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

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant_1_admin)

    visit "/merchant/coupons"

    click_button "Add A Coupon"

    expect(current_path).to eq("/merchant/coupons/new")

    coupon_name = "10% Off"
    coupon_code = "1234"
    coupon_percentage = "10"

    fill_in :name, with: coupon_name
    fill_in :code, with: coupon_code
    fill_in :percentage, with: coupon_percentage

    click_button "Add Coupon"

    expect(current_path).to eq("/merchant/coupons")

    new_coupon = Coupon.last

    expect(page).to have_content(new_coupon.name)
    expect(page).to have_content(new_coupon.code)
    expect(page).to have_content(new_coupon.percentage)
    expect(new_coupon.merchant_id).to eq(merchant_1.id)
  end
end
