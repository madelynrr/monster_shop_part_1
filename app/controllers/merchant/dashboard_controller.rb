class Merchant::DashboardController < Merchant::BaseController
  def index
    @items = Merchant.find(current_user.merchant.id).items
    binding.pry
  end

  def new
  end 

  def create 
    merchant = Merchant.find(current_user.merchant.id)
    item = merchant.items.create(item_params)
      if item.save
        flash[:success] = "You have successfully added an item!"
        redirect_to "/merchant/items"
      else
        flash[:error] = item.errors.full_messages.to_sentence
        render :new
      end
  end 

  def show
  end

private 
  def item_params
    params.permit(:name,:description,:price,:inventory,:image)
  end
end
