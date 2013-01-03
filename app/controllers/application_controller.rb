class ApplicationController < ActionController::Base
  # sb: added authorize filter here to authorize every single action
  #     if only used in admincontroller, shortcomings...
  before_filter :authorize
  before_filter :set_i18n_locale_from_params
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


  protected

    def authorize
      unless User.find_by_id(session[:user_id])
        redirect_to login_url, :notice => "Please sign-in"
      end
    end

    def set_i18n_locale_from_params
      if params[:locale]
        if I18n.available_locales.include?(params[:locale].to_sym)
          I18n.locale = params[:locale]
        else
          flash.now[:notice] = "#{params[:locale]}" +
                               ' translation not available'
          logger.error flash.now[:notice]
        end
      end
    end

# sb: ensure a default locale is picked if URL does not set
    def default_url_options
      { :locale => I18n.locale }
    end
end


