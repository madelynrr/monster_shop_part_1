require 'rails_helper'

RSpec.describe "as a merchant user" do
  it "can navigate to the coupon index page and see all coupons belonging to it" do
    merchant_1 = create(:random_merchant)
    merchant_2 = create(:random_merchant)

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

      coupon_2 = Coupon.create(name: "20% Off",
                  code: "2345",
                  percentage: 10,
                  merchant_id: merchant_1.id)

      coupon_3 = Coupon.create(name: "30% Off",
                  code: "3456",
                  percentage: 10,
                  merchant_id: merchant_2.id)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant_1_admin)

    visit "/merchant/coupons"

    expect(page).to have_content(coupon_1.name)
    expect(page).to have_content(coupon_1.code)
    expect(page).to have_content(coupon_1.percentage)

    expect(page).to have_content(coupon_2.name)
    expect(page).to have_content(coupon_2.code)
    expect(page).to have_content(coupon_2.percentage)

    expect(page).not_to have_content(coupon_3.name)
    expect(page).not_to have_content(coupon_3.code)
    expect(page).not_to have_content(coupon_3.percentage)
  end
end
