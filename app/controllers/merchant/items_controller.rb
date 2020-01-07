class Merchant::ItemsController < Merchant::BaseController

  def destroy
    item = Item.find(params[:id])
    current_user.merchant.items.delete(item)
    item.destroy
    flash[:success] = "You deleted #{item.name}"
    redirect_to "/merchant/items"
  end

  def edit
    @item = Item.find(params[:id])
  end

  def update
    @item = Item.find(params[:id])
  end

end
