class Merchant::CouponsController < Merchant::BaseController

  def index
    @coupons = Coupon.where("merchant_id = #{current_user.merchant.id}")
  end

  def show
    @coupon = Coupon.find(params[:id])
  end

  def new
  end

  def create
    merchant = current_user.merchant
    coupon = merchant.coupons.create(coupon_params)
    if coupon.save
      redirect_to "/merchant/coupons"
    else
      flash[:error] = coupon.errors.full_messages.to_sentence
      render :new
    end
  end

  def edit
    @coupon = Coupon.find(params[:id])
  end

  def update
    @coupon = Coupon.find(params[:id])
    @coupon.update(coupon_params)
    if @coupon.save
      redirect_to "/merchant/coupons/#{@coupon.id}"
    else
      flash.now[:error] = @coupon.errors.full_messages.to_sentence
      render :edit
    end
  end

  def destroy
    coupon = Coupon.find(params[:id])
    coupon.destroy
    redirect_to "/merchant/coupons"
  end

  private
    def coupon_params
      params.permit(:name,:code,:percentage)
    end

end
