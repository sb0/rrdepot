class ApplicationController < ActionController::Base
  protect_from_forgery
  
  private

    def current_cart
#      Cart.find(session[:card_id]) ## stupid typo: card_id vs cart_id
      Cart.find(session[:cart_id])
    rescue ActiveRecord::RecordNotFound
      cart = Cart.create
      session[:cart_id] = cart.id
      cart
    end
end


