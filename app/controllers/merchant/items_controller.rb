class Merchant::ItemsController < Merchant::BaseController

  def destroy
    item = Item.find(params[:id])
    current_user.merchant.items.delete(item)
    item.destroy
    binding.pry
    flash[:success] = "You deleted #{item.name}"
    redirect_to "/merchant/items"
  end

end
