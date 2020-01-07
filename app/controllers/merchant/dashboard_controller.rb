class Merchant::DashboardController < Merchant::BaseController
  def index

  end

  def show
    @merchant = current_user.merchant
  end

  def update
    item = Item.find(params[:id])
    item.toggle_active_status
    flash[:success] = "#{item.name} is deactivated"
    redirect_to '/merchant/items'
  end

end
