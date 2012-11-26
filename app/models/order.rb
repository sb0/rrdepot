class Order < ActiveRecord::Base
  attr_accessible :pay_type, :address, :email, :name
  PAYMENT_TYPES = ["Check", "Credit Card", "Purchase Order"]

  validates :name, :address, :email, :pay_type, :presence => true
  validates :pay_type, :inclusion => PAYMENT_TYPES 

# sb: validates :name, :of, :fields, :condition => value
end
