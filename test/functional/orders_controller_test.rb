require 'test_helper'

class OrdersControllerTest < ActionController::TestCase
  setup do
    @order = orders(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:orders)
  end

  test "requires item in cart" do
    get :new
    assert_redirected_to_store_path
    assert_equal flash[:notice], 'Your cart is empty'
  end

  test "should get new" do
    cart = Cart.create
    session[:cart_id] = cart.id
    LineItem.create(:cart => cart, :product => products(:ruby))

    get :new
    assert_response :success
  end

  test "should create order" do
    assert_difference('Order.count') do
      post :create, :order => { : pay_type => @order. pay_type, :address => @order.address, :email => @order.email, :name => @order.name }
    end

    assert_redirected_to order_path(assigns(:order))
  end

  test "should show order" do
    get :show, :id => @order
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @order
    assert_response :success
  end

  test "should update order" do
    put :update, :id => @order, :order => { : pay_type => @order. pay_type, :address => @order.address, :email => @order.email, :name => @order.name }
    assert_redirected_to order_path(assigns(:order))
  end

  test "should destroy order" do
    assert_difference('Order.count', -1) do
      delete :destroy, :id => @order
    end

    assert_redirected_to orders_path
  end
end
