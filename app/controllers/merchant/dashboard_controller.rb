class Merchant::DashboardController < Merchant::BaseController
  def index

  end

  def show
    @merchant = current_user.merchant
  end
end
