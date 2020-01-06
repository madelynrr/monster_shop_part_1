class Admin::MerchantsController < Admin::BaseController

  def show
    @merchant = Merchant.find(params[:id])
  end

  def update
    merchant = Merchant.find(params[:id])
    merchant.update(status: 1)

    if merchant.save
      flash[:success] = "You have disabled #{merchant.name}"
      redirect_to '/merchants'
    end
  end

end
