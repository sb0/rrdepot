class StoreController < ApplicationController
  skip_before_filter :authorize  
  #layout "test"

  def index
    if params[:set_locale]
      redirect_to store_path(:locale => params[:set_locale])
    else
      @products = Product.all
      @cart = current_cart
      #render(:layout => 'test')
      #render(:layout => 'app')
      #render(:layout => 'moved')
    end
  end
end
