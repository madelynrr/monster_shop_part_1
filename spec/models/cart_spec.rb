require 'rails_helper'

describe Cart, type: :model do
  describe "methods" do
    it ".discounted_total" do
      merchant_1 = create(:random_merchant)
      merchant_2 = create(:random_merchant)
      item_1 = create(:random_item, price: 100, merchant_id: merchant_1.id)
      item_2 = create(:random_item, price: 10, merchant_id: merchant_2.id)

      coupon_1 = Coupon.create(name: "20% Off",
                               code: "1234",
                               percentage: 20,
                               merchant_id: merchant_1.id)


      cart = Cart.new({"#{item_1.id}"=>1, "#{item_2.id}"=>1})
      expect(cart.discounted_total(coupon_1)).to eq(90)
    end
  end
end
