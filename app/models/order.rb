class Order < ActiveRecord::Base
  has_many :line_items, :dependent => :destroy
  attr_accessible :pay_type, :address, :email, :name
  PAYMENT_TYPES = ["Check", "Credit Card", "Purchase Order"]

  validates :name, :address, :email, :pay_type, :presence => true
  validates :pay_type, :inclusion => PAYMENT_TYPES 

# sb: validates :name, :of, :fields, :condition => value

  def add_line_items_from_cart(cart)
    cart.line_items.each do |item|
      item.cart_id = nil
      line_items << item
    end
  end
end
