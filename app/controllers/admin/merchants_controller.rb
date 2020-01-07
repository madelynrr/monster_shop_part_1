class Admin::MerchantsController < Admin::BaseController

  def show
    @merchant = Merchant.find(params[:id])
  end

  def index
    @merchants = Merchant.all
  end

  def update
    merchant = Merchant.find(params[:id])
    merchant.toggle_status
    if merchant.enabled?
      flash[:success] = "You have enabled #{merchant.name}"
    else
      flash[:success] = "You have disabled #{merchant.name}"
    end
    redirect_to '/admin/merchants'
  end

end
