class Notifier < ActionMailer::Base
  default :from => 'RRD Orders <orders@rrdepot.local>'

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.notifier.order_received.subject
  #
  def order_received(order)
    #@greeting = "Hi"
    @order = order

    #mail :to => "to@example.org"
    mail :to => order.email, :subject => "Your order from RRD has been received"
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.notifier.order_shipped.subject
  #
  def order_shipped(order)
    #@greeting = "Hi"
    @order = order

    #mail :to => "to@example.org"
    mail :to => order.email, :subject => 'Your order from RRD has been shipped'
  end
end
