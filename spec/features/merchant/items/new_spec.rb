require 'rails_helper'

RSpec.describe 'As a merchant admin/user' do 
    before :each do 
    
        @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
        @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
        @chain = @meg.items.create(name: "Chain", description: "It'll never break!", price: 50, image: "https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588", inventory: 5)
        @shifter = @meg.items.create(name: "Shimano Shifters", description: "It'll always shift!", active?: false, price: 180, image: "https://images-na.ssl-images-amazon.com/images/I/4142WWbN64L._SX466_.jpg", inventory: 2)
        
        @merchant_admin = create(:random_user, role: 2, merchant: @meg)

        @merchant_2 = create(:random_merchant)
        @item_2 = create(:random_item, merchant: @merchant_2)

    end 

  it "can add new items to sell in my store with image added" do 

    visit '/'

    click_link "Login"

    fill_in :email, with: @merchant_admin.email
    fill_in :password, with: @merchant_admin.password

    click_button "Login"

    visit "/merchant/items"
    
    click_on "Add New Item"
   
    expect(current_path).to eq("/merchant/items/new")
    fill_in :name, with: "FIG x New Balance 996"
    fill_in :price, with: 100
    fill_in :image, with: "https://cdn.shopify.com/s/files/1/0139/8942/products/Womens_New_Balance_996_black-1_900x900.jpg"
    fill_in :description, with: "Dope biking shoes in black."
    fill_in :inventory, with: 10

    click_on "Create Item"

    expect(current_path).to eql("/merchant/items")

    expect(page).to have_content("You have successfully added an item!")

    new_item = Item.last

    expect(page).to_not have_content("#{@item_2.name}")
    expect(page).to_not have_content("#{@item_2.description}")

    expect(page).to have_content("FIG x New Balance 996")
    expect(page).to have_content("Dope biking shoes in black.")
    expect(page).to have_content("Price: $100.00")
    expect(page).to have_content("Inventory: 10")
    expect(page).to have_content("You have successfully added an item!")
    expect(page).to have_css("img[src*='https://cdn.shopify.com/s/files/1/0139/8942/products/Womens_New_Balance_996_black-1_900x900.jpg']")

  end

  it "can add new items to sell in my store with no image added" do 
    visit '/'

    click_link "Login"

    fill_in :email, with: @merchant_admin.email
    fill_in :password, with: @merchant_admin.password

    click_button "Login"

    visit "/merchant/items"
    
    click_on "Add New Item"
   
    expect(current_path).to eq("/merchant/items/new")
    fill_in :name, with: "Pearl Izumi Winter Bike Gloves"
    fill_in :price, with: 95
    fill_in :description, with: "Whether battling wintertime chill on a fatbike in Minnesota, or tackling a frigid Colorado cyclocross race in late December, this is our warmest winter glove."
    fill_in :inventory, with: 5

    click_button "Create Item"

    expect(current_path).to eql("/merchant/items")
    expect(page).to have_content("You have successfully added an item!")

    new_item = Item.last

    expect(page).to have_content("Pearl Izumi Winter Bike Gloves")
    expect(page).to have_content("Whether battling wintertime chill on a fatbike in Minnesota, or tackling a frigid Colorado cyclocross race in late December, this is our warmest winter glove.")
    expect(page).to have_content("Price: $95.00")
    expect(page).to have_content("Inventory: 5")
    expect(page).to have_css("img[src*='https://literalminded.files.wordpress.com/2010/11/image-unavailable1.png']")
  
  end
end 