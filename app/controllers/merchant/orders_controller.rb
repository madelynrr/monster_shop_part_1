class Merchant::OrdersController < Merchant::BaseController

  def show
    @order = Order.find(params[:id])
  end

  def update
    require 'pry', binding.pry
  end

end
