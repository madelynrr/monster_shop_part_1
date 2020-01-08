class Admin::DashboardController < Admin::BaseController
  def index
    @orders = Order.all
  end

  def update
    order = Order.find(params[:id])
    order.ship
    redirect_to '/admin'
  end
end
