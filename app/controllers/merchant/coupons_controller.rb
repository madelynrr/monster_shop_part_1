class Merchant::CouponsController < Merchant::BaseController

  def index
    @coupons = Coupon.where("merchant_id = #{current_user.merchant.id}")
  end

end
