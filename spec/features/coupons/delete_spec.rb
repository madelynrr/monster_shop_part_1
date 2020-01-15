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

  it "can delete a coupon from the show page" do
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

      click_button "Delete Coupon"

      expect(current_path).to eq("/merchant/coupons")
      expect(page).not_to have_css("#coupon-#{coupon_1.id}")
  end

  xit "cannot delete a coupon that has been used on an order" do
    merchant = create(:random_merchant)
    user = create(:random_user)
    item_1 = create(:random_item, price: 100, merchant_id: merchant.id)
    coupon_1 = Coupon.create(name: "20% Off",
                             code: "1234",
                             percentage: 20,
                             merchant_id: merchant.id)

    visit "/"
    click_link "Login"
    fill_in :email, with: user.email
    fill_in :password, with: user.password
    click_button "Login"

    visit "/items/#{item_1.id}"
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

    visit "/merchant/coupons/#{coupon_1.id}"

    click_button "Delete Coupon"

    expect(page).not_to have_css("#coupon-#{coupon_1.id}")

    expect(page).to have_content("Cannot delete coupon, already applied to an order.")
  end
end
