class Merchant::CouponsController < Merchant::BaseController

  def index
    @coupons = Coupon.where("merchant_id = #{current_user.merchant.id}")
  end

  def new
  end

  def create
    merchant = current_user.merchant
    merchant.coupons.create(coupon_params)
    redirect_to "/merchant/coupons"
  end

  private
    def coupon_params
      params.permit(:name,:code,:percentage)
    end

end
