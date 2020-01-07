class Merchant::DashboardController < Merchant::BaseController
  def index

  end

  def show
    @merchant = current_user.merchant
  end

  def update
    item = Item.find(params[:id])
    item.toggle_active_status
    if item.active?
      flash[:success] = "#{item.name} is Activated"
    else
      flash[:success] = "#{item.name} is deactivated"
    end 
    redirect_to '/merchant/items'
  end

end
