class Merchant::DashboardController < Merchant::BaseController
  def index
    @orders = current_user.merchant.orders.distinct
  end

  def new
  end

  def show
  end

  def update
  end

end 
