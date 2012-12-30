class LineItem < ActiveRecord::Base
# sb: what if I don't want to add :product to attr_accessible?
# sb: is there a more secure way then to allow for mass-assignment ??
  attr_accessible :cart_id, :product_id, :product, :quantity
  # sb: test failed in order_controller_test with LineItems.create
  # LineItems.create can't mass-assign cart, so hence line below:
  attr_accessible :cart
# sb: same as above but makes the db relationship with the other models
# sb: and the corresponding tables (this is why you will see _id appended)
# sb: it also protects against mass-assignment on the cart_id, product_id
# sb: so you must explicitly set with attr_accessible as above
# sb: so since belongs_to relationship.. needs id for each belong_to for lookup
  belongs_to :order
  belongs_to :product
  belongs_to :cart


  def total_price
    product.price * quantity
  end
end
