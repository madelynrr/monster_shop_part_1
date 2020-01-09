require 'rails_helper'

RSpec.describe 'merchant show page', type: :feature do
  describe 'As a user' do
    before :each do
      @bike_shop = Merchant.create(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Richmond', state: 'VA', zip: 23137)
      @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @brian = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)

      @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      @pull_toy = @brian.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
      @dog_bone = @brian.items.create(name: "Dog Bone", description: "They'll love it!", price: 20, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:false, inventory: 21)

      user = create(:random_user)

      @order_1 = user.orders.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033)
      @order_2 = user.orders.create!(name: 'Brian', address: '123 Zanti St', city: 'Denver', state: 'CO', zip: 80204)
      @order_3 = user.orders.create!(name: 'Mike', address: '123 Dao St', city: 'Denver', state: 'CO', zip: 80210)

      @order_1.item_orders.create!(item: @tire, price: @tire.price, quantity: 2)
      @order_1.item_orders.create!(item: @pull_toy, price: @pull_toy.price, quantity: 3)
      @order_2.item_orders.create!(item: @dog_bone, price: @dog_bone.price, quantity: 2)
      @order_2.item_orders.create!(item: @pull_toy, price: @pull_toy.price, quantity: 2)
      @order_2.item_orders.create!(item: @tire, price: @tire.price, quantity: 2)
      @order_3.item_orders.create!(item: @dog_bone, price: @dog_bone.price, quantity: 5)
    end

    it 'I can see a merchants name, address, city, state, zip' do
      visit "/merchants/#{@bike_shop.id}"

      expect(page).to have_content("Brian's Bike Shop")
      expect(page).to have_content("123 Bike Rd.\nRichmond, VA 23137")
    end

    it 'I can see a link to visit the merchant items' do
      visit "/merchants/#{@bike_shop.id}"

      expect(page).to have_link("All #{@bike_shop.name} Items")

      click_on "All #{@bike_shop.name} Items"

      expect(current_path).to eq("/merchants/#{@bike_shop.id}/items")
    end

    it 'displays that merchants items' do
      merchant_user = create(:random_user, merchant_id: @bike_shop.id, role: 3)
      merchant = create(:random_merchant)

      item_1 = create(:random_item, merchant_id: @bike_shop.id)
      item_2 = create(:random_item, merchant_id: @bike_shop.id)
      item_3 = create(:random_item, merchant_id: merchant.id)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant_user)

      visit "/merchant/items"
      within "#item-#{item_1.id}" do
        expect(page).to have_content(item_1.name)
        expect(page).to have_content(item_1.description)
        expect(page).to have_content(item_1.price)
        expect(page).to have_content("Active")
        expect(page).to have_content(item_1.inventory)
        expect(page).to have_css("img[src*='#{item_1.image}']")
      end

      within "#item-#{item_2.id}" do
        expect(page).to have_content(item_2.name)
        expect(page).to have_content(item_2.description)
        expect(page).to have_content(item_2.price)
        expect(page).to have_content("Active")
        expect(page).to have_content(item_2.inventory)
        expect(page).to have_css("img[src*='#{item_2.image}']")
      end

      expect(page).to_not have_css("#item-#{item_3.id}")
    end

    it 'has button to deactive an item next to each item' do

      merchant_user = create(:random_user, merchant_id: @bike_shop.id, role: 3)

      item_1 = create(:random_item, merchant_id: @bike_shop.id)
      item_2 = create(:random_item, merchant_id: @bike_shop.id)
      item_3 = create(:random_item, merchant_id: @bike_shop.id, active?: false)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant_user)

      visit '/merchant/items'

      within "#item-#{item_1.id}" do
        expect(page).to have_button("Deactivate")
      end

      within "#item-#{item_3.id}" do
        expect(page).to_not have_button("Deactivate")
      end

      within "#item-#{item_2.id}" do
        click_button "Deactivate"
      end

      expect(current_path).to eq("/merchant/items")
      expect(page).to have_content("#{item_2.name} is deactivated")
      item_1.reload
      item_2.reload
      item_3.reload
      expect(item_1.active?).to eq(true)
      expect(item_2.active?).to eq(false)
      expect(item_3.active?).to eq(false)

    end
    it 'can activate a deactivated item' do
      merchant_user = create(:random_user, merchant_id: @bike_shop.id, role: 3)

      item_1 = create(:random_item, merchant_id: @bike_shop.id)
      item_2 = create(:random_item, merchant_id: @bike_shop.id, active?: false)
      item_3 = create(:random_item, merchant_id: @bike_shop.id, active?: false)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant_user)

      visit '/merchant/items'

      within "#item-#{item_1.id}" do
        expect(page).not_to have_button("Activate")
      end

      within "#item-#{item_2.id}" do
        expect(page).to have_button("Activate")
      end

      within "#item-#{item_3.id}" do
        click_button("Activate")
      end

      expect(current_path).to eq("/merchant/items")
      expect(page).to have_content("#{item_3.name} is Activated")
      item_1.reload
      item_2.reload
      item_3.reload
      expect(item_1.active?).to eq(true)
      expect(item_2.active?).to eq(false)
      expect(item_3.active?).to eq(true)

    end

    it 'I can see a merchants statistics' do
      visit "/merchants/#{@brian.id}"

      within ".merchant-stats" do
        expect(page).to have_content("Number of Items: 2")
        expect(page).to have_content("Average Price of Items: $15")
        within ".distinct-cities" do
          expect(page).to have_content("Cities that order these items:")
          expect(page).to have_content("Hershey")
          expect(page).to have_content("Denver")
        end
      end
    end
  end
end
