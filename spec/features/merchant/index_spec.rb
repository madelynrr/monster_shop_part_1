require 'rails_helper'

RSpec.describe 'as a merchant', type: :feature do

  before :each do
    @merchant_company = Merchant.create(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Richmond', state: 'VA', zip: 80203)

    @merchant_admin = User.create(name: "Jordan",
      address: "394 High St",
      city: "Denver",
      state: "CO",
      zip_code: "80602",
      email: "hotones@hotmail.com",
      password: "password",
      password_confirmation: "password",
      role: 2)

    @merchant_employee = User.create(name: "Jordi",
      address: "394 High St",
      city: "Denver",
      state: "CO",
      zip_code: "80602",
      email: "hotfours@hotmail.com",
      password: "password",
      password_confirmation: "password",
      role: 3)

      @user = create(:random_user)

      @merchant_company.users << [@merchant_admin, @merchant_employee]
  end

  it "redirects me to merchant dashboard after login" do
    visit '/login'
    fill_in :email, with: @merchant_admin.email
    fill_in :password, with: @merchant_admin.password
    click_button "Login"

    expect(current_path).to eq('/merchant')
    expect(page).to have_content("Welcome, #{@merchant_admin.name}, you are logged in!")
    click_link "Log Out"

    visit '/login'
    fill_in :email, with: @merchant_employee.email
    fill_in :password, with: @merchant_employee.password
    click_button "Login"

    expect(current_path).to eq('/merchant')
    expect(page).to have_content("Welcome, #{@merchant_employee.name}, you are logged in!")
  end

  it "displays full address of the merchant I work for" do
    visit '/login'
    fill_in :email, with: @merchant_admin.email
    fill_in :password, with: @merchant_admin.password
    click_button "Login"

    expect(page).to have_content(@merchant_company.name)
    expect(page).to have_content(@merchant_company.address)
    expect(page).to have_content(@merchant_company.city)
    expect(page).to have_content(@merchant_company.state)
    expect(page).to have_content(@merchant_company.zip)
    click_link "Log Out"

    visit '/login'
    fill_in :email, with: @merchant_employee.email
    fill_in :password, with: @merchant_employee.password
    click_button "Login"

    expect(page).to have_content(@merchant_company.name)
    expect(page).to have_content(@merchant_company.address)
    expect(page).to have_content(@merchant_company.city)
    expect(page).to have_content(@merchant_company.state)
    expect(page).to have_content(@merchant_company.zip)
  end

  describe 'On the merchant dashboard' do
    it "shows any orders containing my items" do
      mike = Merchant.create(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)

      tire = @merchant_company.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      paper = @merchant_company.items.create(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 8)
      pencil = mike.items.create(name: "Yellow Pencil", description: "You can write on paper with it!", price: 2, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 100)

      order_1 = @user.orders.create(name: "Jordan", address: "123 Hi Road", city: "Cleveland", state: "OH", zip: "44333")
      order_2 = create(:random_order, user: @user)
      order_3 = create(:random_order, user: @user)

      tire_order = ItemOrder.create!(item: tire, order: order_1, price: tire.price, quantity: 5)
      paper_order = ItemOrder.create!(item: paper, order: order_1, price: paper.price, quantity: 3)
      pencil_order = ItemOrder.create!(item: pencil, order: order_2, price: pencil.price, quantity: 9)
      tire_order_2 = ItemOrder.create!(item: tire, order: order_3, price: tire.price, quantity: 3)
      pencil_order_2 = ItemOrder.create!(item: pencil, order: order_3, price: pencil.price, quantity: 4)

      visit '/login'
      fill_in :email, with: @merchant_employee.email
      fill_in :password, with: @merchant_employee.password
      click_button "Login"

      visit '/merchant'

      within "#order-#{order_1.id}" do
        expect(page).to have_link("#{order_1.id}")
        expect(page).to have_content(order_1.created_at)
        expect(page).to have_content("Quantity of my items in this order: 8")
        expect(page).to have_content("Value of my items in this order: 560")
      end

      within "#order-#{order_3.id}" do
        expect(page).to have_link("#{order_3.id}")
        expect(page).to have_content(order_3.created_at)
        expect(page).to have_content("Quantity of my items in this order: 3")
        expect(page).to have_content("Value of my items in this order: 300")
      end

      expect(page).to_not have_css("#order-#{order_2.id}")

#       As a merchant
# When I visit my merchant dashboard ("/merchant")
# If any users have pending orders containing items I sell
# Then I see a list of these orders.
# Each order listed includes the following information:
#
# the ID of the order, which is a link to the order show page ("/merchant/orders/15")
# the date the order was made
# the total quantity of my items in the order
# the total value of my items for that order
    end
  end
end
