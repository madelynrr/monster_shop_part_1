require 'rails_helper'

RSpec.describe "as a merchant user" do
  it "can navigate to the coupon index page and see all coupons" do
    merchant_company = Merchant.create(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Richmond', state: 'VA', zip: 80203)

    merchant_admin = User.create(name: "Jordan",
                           address: "394 High St",
                           city: "Denver",
                           state: "CO",
                           zip_code: "80602",
                           email: "hotones@hotmail.com",
                           password: "password",
                           password_confirmation: "password",
                           role: 2)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant_admin)

    visit "/merchant/coupons"

    e

  end
end
