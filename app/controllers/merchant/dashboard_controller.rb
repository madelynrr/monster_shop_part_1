class Merchant::DashboardController < Merchant::BaseController
  def index
  
  end

  def new
  end 

  def create 
    merchant = Merchant.find(current_user.merchant.id)
    item = merchant.items.create(item_params)
      if item.image == ""
        item.image = "https://literalminded.files.wordpress.com/2010/11/image-unavailable1.png"
      end
      if item.save
        flash[:success] = "You have successfully added an item!"
        redirect_to "/merchant/items"
      else
        flash[:error] = item.errors.full_messages.to_sentence
        render :new
      end
  end 

  def show
    @items = Merchant.find(current_user.merchant.id).items
  end

private 
  def item_params
    params.permit(:name,:description,:price,:inventory,:image)
  end
end
