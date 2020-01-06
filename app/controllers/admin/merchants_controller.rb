class Admin::MerchantsController < Admin::BaseController

  def show
    @merchant = Merchant.find(params[:id])
  end

  def update
    merchant = Merchant.find(params[:id])
    if merchant.enabled?
      merchant.update(status: 1)
      flash[:success] = "You have disabled #{merchant.name}"
    elsif merchant.disabled?
      merchant.update(status: 0)
      flash[:success] = "You have enabled #{merchant.name}"
    end
    redirect_to '/merchants'
  end

end
