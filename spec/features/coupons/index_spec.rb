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

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant_1_admin)

    visit "/merchant/coupons"

    e

  end
end
