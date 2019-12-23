require 'rails_helper'

RSpec.describe "as a user" do
  it "can login with valid credentials" do
    user = create(:random_user)

    visit '/'

    click_link "Login"
    expect(current_path).to eq('/login')

    fill_in :email, with: user.email
    fill_in :password, with: user.password

    click_button "Login"

    expect(current_path).to eq('/profile')
    expect(page).to have_content("Welcome, #{user.name}, you are logged in!")

    within "nav" do
      expect(page).not_to have_link("Login")
      expect(page).not_to have_link("Register")
      expect(page).to have_link("Log Out")
    end
  end

  it "cannot login with invalid credentials" do
    user = create(:random_user)

    visit '/login'

    fill_in :email, with: 'prisonmike@gmail.com'
    fill_in :password, with: user.password

    click_button 'Login'

    expect(current_path).to eq('/login')
    expect(page).not_to have_link('Logout')
    expect(page).to have_content('Invalid email or password')

    fill_in :email, with: user.email
    fill_in :password, with: 'jumbalaya'
    click_button 'Login'

    expect(current_path).to eq('/login')
    expect(page).not_to have_link('Logout')
    expect(page).to have_content('Invalid email or password')

    fill_in :email, with: 'prisonmike@gmail.com'
    fill_in :password, with: 'jumbalaya'
    click_button "Login"

    expect(current_path).to eq('/login')
    expect(page).not_to have_link('Logout')
    expect(page).to have_content('Invalid email or password')
  end

  it "cannot login to admin or merchant dashboard if user is default user" do
    user = create(:random_user)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

    visit "/admin"
    expect(page).to have_content("The page you were looking for doesn't exist.")

    visit "/merchant"
    expect(page).to have_content("The page you were looking for doesn't exist.")
  end

  describe 'as a merchant' do
    it "redirects me to merchant dashboard after login" do
      bike_shop = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      merchant = create(:random_user, role: 2)
      bike_shop.users << merchant

      visit '/login'

      fill_in :email, with: merchant.email
      fill_in :password, with: merchant.password

      click_button "Login"

      expect(current_path).to eq('/merchant')
      expect(page).to have_content("Welcome, #{merchant.name}, you are logged in!")
    end
  end

  describe "all users can log out" do
     it 'can log out as a registered user' do
        user = create(:random_user)

        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

        @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)

        @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
        visit "/items/#{@tire.id}"
        click_on "Add To Cart"
        click_on "Log Out"



        expect(current_path).to eq("/")
        expect(page).to have_content("You have been logged out")
        expect(page).to have_content("Cart: 0")
    end
  end

  describe 'as an admin/merchant/user when logged in' do
    it 'redirects when they visit the login path for admin' do
      admin = create(:random_user, role: 1)

      visit '/login'

      fill_in :email, with: admin.email
      fill_in :password, with: admin.password

      click_button "Login"

      visit '/login'

      expect(current_path).to eq('/admin')
      expect(page).to have_content("#{admin.name}, you are already logged in!")
    end

    it 'redirects when they visit the login path for merchant' do
      bike_shop = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      merchant = create(:random_user, role: 2)
      bike_shop.users << merchant

      visit '/login'

      fill_in :email, with: merchant.email
      fill_in :password, with: merchant.password

      click_button "Login"

      visit '/login'
      expect(current_path).to eq('/merchant')
      expect(page).to have_content("#{merchant.name}, you are already logged in!")
    end

    it 'redirects when they visit the login path for a user' do
      user = create(:random_user)

      visit '/login'

      fill_in :email, with: user.email
      fill_in :password, with: user.password

      click_button "Login"

      visit '/login'
      expect(current_path).to eq('/profile')
      expect(page).to have_content("#{user.name}, you are already logged in!")
    end
  end
end
