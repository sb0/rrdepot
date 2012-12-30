require 'test_helper'

class CheckoutOneItemTest < ActionDispatch::IntegrationTest
  # sb: First and foremost, load the needed fixtures for your tests
  fixtures :products
  # test "the truth" do
  #   assert true
  # end

  test "buying one product" do
    # sb: Clear line_items and orders tables for cleaner test
    LineItem.delete_all
    Order.delete_all
    ruby_book = products(:ruby)

    # sb: prospect goes to store index page
    get "/"
    assert_response :success
    assert_template "index"
   
    #sb: prospect selects a product, which adds to cart
    #    since ajax is used to add items to cart use xml_http_request
    xml_http_request :post, '/line_items', :product_id => ruby_book.id    
    assert_response :success

    # sb: get current cart from session
    cart = Cart.find(session[:cart_id])
    # sb: assert an item was added to cart
    assert_equal 1, cart.line_items.size
    # sb: assert that item is the intended product from above
    assert_equal ruby_book, cart.line_items[0].product

    # sb: prospect clicks Check out button
    get "/orders/new"
    assert_response :success
    assert_template "new"

    # sb: prospect needs to fill out order details and submit order
    post_via_redirect "/orders", :order => { :name     => "Purchase Prospect",
                                             :address  => "123 Street"
                                             :email    => "fake@email.net"
                                             :pay_type => "Check" }
    assert_response :success
    # sb: application redirects back to desired location after order complete
    assert_template "index"
    # sb: Get the cart from the session again and confirm its empty
    cart = Cart.find(session[:cart_id])
    assert_equal 0, cart.line_items.size

    # sb: Confirm database has corresponding results
    orders = Orders.all
    assert_equal 1, orders.size
    order = orders[0]
    
    assert_equal "Purchase Prospect", orders.name
    assert_equal "123 Street", orders.address
    assert_equal "fake@email.net", orders.email
    assert_equal "Check", orders.pay_type

    # sb: confirm order has one item
    assert_equal 1, order.line_items.size
    # sb: confirm item is intended product from above
    line_item = order.line_items[0]
    assert_equal ruby_book, line_item.product

    # sb: verify mailer
    mail = ActionMailer::Base.deliveries.last
    assert_equal ["fake@email.net"], mail.to
    assert_equal 'RR Depot <rrdepot@sbpro.net>', mail[:from].value
    assert_equal 'RR Depot: Your Order Details', mail.subject
  end 
end
