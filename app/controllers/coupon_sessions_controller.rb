class CouponSessionsController < ApplicationController

  def create
    coupon = Coupon.find_by(code: params[:coupon_code])
    if coupon
      session[:coupon] = coupon.id
    else
      flash[:error] = "#{params[:coupon_code]} is not a valid coupon code."
    end

    redirect_to "/cart"
  end
end
