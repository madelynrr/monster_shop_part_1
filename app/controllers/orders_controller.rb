class OrdersController <ApplicationController

  def new
  end

  def index
    @user = current_user
  end

  def show
    @order = Order.find(params[:id])
  end

  def create
    order = current_user.orders.create(order_params)
    if order.save
      cart.items.each do |item,quantity|
        order.item_orders.create({
          item: item,
          quantity: quantity,
          price: item.price
          })
      end
      order.apply_coupon(current_coupon.id) if current_coupon
      session.delete(:cart)
      flash[:success] = 'You have placed your order!'
      redirect_to '/profile/orders'
    else
      flash[:notice] = "Please complete address form to create an order."
      render :new
    end
  end

  def update
    order = Order.find(params[:id])
    order.cancel
    redirect_to "/profile"
    flash[:notice] = "Your order has been cancelled."
  end


  private

  def order_params
    params.permit(:name, :address, :city, :state, :zip, :current_status)
  end

  # def create_item_order(cart)
  #
  # end
end
