class Merchant::DashboardController < Merchant::BaseController
  def index

  end

  def new
  end

  def show
    @items = Merchant.find(current_user.merchant.id).items
  end

  def update
  end

private 
  def item_params
    params.permit(:name,:description,:price,:inventory,:image)
  end
end
