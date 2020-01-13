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

  it "does not create coupon if fields not filled in" do
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

    coupon_name = "10% Off"
    coupon_code = "1234"

    fill_in :name, with: coupon_name
    fill_in :code, with: coupon_code

    click_button "Add Coupon"

    expect(page).to have_content("Percentage can't be blank")
  end

  it "doesn't create coupon if code or name are already in the database" do
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

    coupon_1 = Coupon.create(name: "10% Off",
                code: "1234",
                percentage: 10,
                merchant_id: merchant_1.id)

    name = "10% Off"
    code = "1234"
    percentage = 10

    visit "/merchant/coupons"

    click_button "Add A Coupon"

    fill_in :name, with: name
    fill_in :code, with: code
    fill_in :percentage, with: percentage

    click_button "Add Coupon"

    expect(page).to have_content("Name has already been taken")
    expect(page).to have_content("Code has already been taken")
  end

  it "cannot create coupon if percentage is more than 100" do
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

    visit "/merchant/coupons/new"

    name = "10% Off"
    code = "1234"
    percentage = 101

    fill_in :name, with: name
    fill_in :code, with: code
    fill_in :percentage, with: percentage

    click_button "Add Coupon"

    expect(page).to have_content("Percentage needs to be between 0 and 100.")
  end
end
