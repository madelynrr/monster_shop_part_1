require 'rails_helper'

RSpec.describe "Items Index Page" do
  describe "When I visit the items index page" do
    before(:each) do
      @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @brian = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)

      @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)

      @pull_toy = @brian.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
      @dog_bone = @brian.items.create(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:false, inventory: 21)
    end

    it "all items or merchant names are links" do
      visit '/items'

      within "#item-#{@tire.id}" do
        expect(page).to have_link(@tire.name)
        expect(page).to have_link(@tire.merchant.name)
      end

      within "#item-#{@pull_toy.id}" do
        expect(page).to have_link(@pull_toy.name)
        expect(page).to have_link(@pull_toy.merchant.name)
      end

      expect(page).not_to have_css("#item-#{@dog_bone.id}")
    end

    it "I can see a list of all of the items" do

      visit '/items'

      within "#item-#{@tire.id}" do
        expect(page).to have_link(@tire.name)
        expect(page).to have_content(@tire.description)
        expect(page).to have_content("Price: $#{@tire.price}")
        expect(page).to have_content("Active")
        expect(page).to have_content("Inventory: #{@tire.inventory}")
        expect(page).to have_link(@meg.name)
        expect(page).to have_css("img[src*='#{@tire.image}']")
      end

      within "#item-#{@pull_toy.id}" do
        expect(page).to have_link(@pull_toy.name)
        expect(page).to have_content(@pull_toy.description)
        expect(page).to have_content("Price: $#{@pull_toy.price}")
        expect(page).to have_content("Active")
        expect(page).to have_content("Inventory: #{@pull_toy.inventory}")
        expect(page).to have_link(@brian.name)
        expect(page).to have_css("img[src*='#{@pull_toy.image}']")
      end

      expect(page).not_to have_css("#item-#{@dog_bone.id}")
    end

    it "only displays active items" do
      dog_shop = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)

      pull_toy = dog_shop.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
      dog_bone = dog_shop.items.create(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:false, inventory: 21)

      visit "/items"

      expect(page).to have_css("#item-#{pull_toy.id}")
      expect(page).to have_content(pull_toy.name)
      expect(page).not_to have_css("#item-#{dog_bone.id}")
      expect(page).not_to have_content(dog_bone.name)
    end

    it "can click item image to go to item show page" do
      dog_shop = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)

      pull_toy = dog_shop.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)

      visit "/items"

      click_link "#{pull_toy.id}-image"

      expect(current_path).to eq("/items/#{pull_toy.id}")
    end

    it "shows most and least popular items" do
      user = create(:random_user)

      item_1 = create(:random_item, merchant_id: @meg.id)
      item_2 = create(:random_item, merchant_id: @meg.id)
      item_3 = create(:random_item, merchant_id: @meg.id)
      item_4 = create(:random_item, merchant_id: @meg.id)
      item_5 = create(:random_item, merchant_id: @meg.id)
      item_6 = create(:random_item, merchant_id: @meg.id)
      item_7 = create(:random_item, merchant_id: @meg.id)

      order_1 = user.orders.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033)
      order_2 = user.orders.create!(name: 'Madi', address: '123 Hi Ave', city: 'Denver', state: 'CO', zip: '80211')

      ItemOrder.create!(item: item_1, order: order_1, price: item_1.price, quantity: 5)
      ItemOrder.create!(item: item_1, order: order_2, price: item_1.price, quantity: 3)
      ItemOrder.create!(item: item_2, order: order_1, price: item_2.price, quantity: 9)
      ItemOrder.create!(item: item_3, order: order_1, price: item_3.price, quantity: 4)
      ItemOrder.create!(item: item_3, order: order_2, price: item_3.price, quantity: 2)
      ItemOrder.create!(item: item_4, order: order_2, price: item_4.price, quantity: 7)
      ItemOrder.create!(item: item_5, order: order_2, price: item_5.price, quantity: 12)
      ItemOrder.create!(item: item_6, order: order_2, price: item_6.price, quantity: 3)
      ItemOrder.create!(item: item_7, order: order_2, price: item_7.price, quantity: 10)

      visit '/items'

      within "#stats" do
        within "#most-popular" do
          expect(page).to have_content("Most popular items on the site:")
          expect(page).to have_content(item_5.name)
          expect(page).to have_content(item_7.name)
          expect(page).to have_content(item_2.name)
          expect(page).to have_content(item_1.name)
          expect(page).to have_content(item_4.name)
          expect(page).to_not have_content(item_3.name)
          expect(page).to_not have_content(item_6.name)
        end

        within "#least-popular" do
          expect(page).to have_content("Not our best sellers:")
          expect(page).to have_content(item_6.name)
          expect(page).to have_content(item_3.name)
          expect(page).to have_content(item_2.name)
          expect(page).to have_content(item_1.name)
          expect(page).to have_content(item_4.name)
          expect(page).to_not have_content(item_5.name)
          expect(page).to_not have_content(item_7.name)
        end
      end
    end
  end
end
