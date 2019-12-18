
require 'rails_helper'

RSpec.describe 'Site Navigation' do
  describe 'As a Visitor' do
    it "I see a nav bar with links to all pages" do
      visit '/merchants'

      within 'nav' do
        click_link 'All Items'
      end

      expect(current_path).to eq('/items')

      within 'nav' do
        click_link 'All Merchants'
      end

      expect(current_path).to eq('/merchants')
    end

    it "I can see a cart indicator on all pages" do
      visit '/merchants'
      within 'nav' do
        click_link "Cart: 0"
      end
      expect(current_path).to eq("/cart")

      visit '/items'
      within 'nav' do
        click_link "Cart: 0"
      end
      expect(current_path).to eq("/cart")
    end

    it "has link to return to home page" do
      visit "/items"

      within "nav" do
        click_link ("Monster Shop")

        expect(current_path).to eq("/")
      end
    end

    it "has login and register links" do
      visit "/merchants"

      within "nav" do
        click_link "Login"
        expect(current_path).to eq("/login")
      end

      within "nav" do
        click_link "Register"
        expect(current_path).to eq("/register")
      end
    end

  end
end
