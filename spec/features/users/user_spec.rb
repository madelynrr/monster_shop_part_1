require 'rails_helper'

RSpec.describe 'As a user' do
  it 'does not allow me to go to merchant or admin pages' do

    user = create(:random_user, role: 0)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

    expect(user.role).to eq("default")

    visit '/admin'
    expect(page).to have_content("The page you were looking for doesn't exist (404)")

    visit '/merchant'
    expect(page).to have_content("The page you were looking for doesn't exist (404)")

  end

  it "can see the user's profile" do

    user = create(:random_user, role: 0)

    visit '/'

    click_link "Login"
    expect(current_path).to eq('/login')

    fill_in :email, with: user.email
    fill_in :password, with: user.password

    click_button "Login"

    expect(page).to have_content("#{user.name}")
    expect(page).to have_content("#{user.address}")
    expect(page).to have_content("#{user.city}")
    expect(page).to have_content("#{user.state}")
    expect(page).to have_content("#{user.zip_code}")
    expect(page).to have_content("#{user.email}")

    expect(page).to have_link("Edit Profile")
  end

  it "can display users order link from user's profile" do

    user = create(:random_user, role: 0)
    meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
    brian = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)
    tire = meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
    pull_toy = brian.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
    dog_bone = brian.items.create(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:false, inventory: 21)
    new_order = Order.create(name:"Bert",address: "123 Sesame St.", city: "NYC", state: "New York", zip: 10001)
    visit '/'

    click_link "Login"
    expect(current_path).to eq('/login')

    fill_in :email, with: user.email
    fill_in :password, with: user.password

    click_button "Login"

    visit "/items/#{tire.id}"
    click_on "Add To Cart"
    visit "/items/#{pull_toy.id}"
    click_on "Add To Cart"

    visit "/cart"
    click_on "Checkout"
    click_button "Create Order"

    visit '/profile'

    expect(page).to have_link("My Orders")

    click_on "My Orders"

    expect(current_path).to eq("/profile/orders")
  end

  describe 'registered user can not edit profile email that belongs to other user' do
    it 'redirects back to edit profile page and displays flash message if duplicate' do

      user2 = create(:random_user, role: 0)
      user = create(:random_user, role: 0)
      visit '/'
      click_link "Login"
      fill_in :email, with: user.email
      fill_in :password, with: user.password
      click_button "Login"
      expect(current_path).to eq("/profile")
      click_link "Edit Profile"
      fill_in :email, with: user2.email
      click_button "Submit"

      expect(page).to have_content("Email has already been taken")
      expect(current_path).to eq('/profile/edit')

    end
  end
end
