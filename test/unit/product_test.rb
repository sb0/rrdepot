###############################################################################
# Samba Keita
# 2012.09.07 0209
# Copyright. All Rights Reserved.
# You do not have any rights to use this file besides to view and learn.
# Do not obtain profit, funds, monies, currency 
# or any monetary value with this file.
# Do not share. Must be invited to this file BY ME.
###############################################################################
# product_test.rb 
# Learning tool for writing unit tests
#==============================================================================
# sb: obviously some lib is needed to write the tests easier
require 'test_helper'

# sb: create a class that inherits from ActiveSupport::TestCase
# sb: subclass< ActiveSupport::TestCase
# sb: instead of def like normal Ruby methods use TEST (test/do blocks)
class ProductTest < ActiveSupport::TestCase
# sb: control which fixture to load from here (recall db/model name matching)
  fixtures :products
# sb: simple test to check if any product instance is EMPTY
  test "products cant be empty" do
    product = Product.new
    assert product.invalid?
    assert product.errors[:title].any?
    assert product.errors[:description].any?
    assert product.errors[:price].any?
    assert product.errors[:image_url].any?
  end

# sb: test PRICE FOR ZERO (>=0.01) **very important THIS MEANS MONEY
# sb: note you could break this apart into 3 tests (-1,0,1)
  test "product price must be positive" do
    product = Product.new(:title	=> "Triple Stage Darkness-must-be-unique-or-test-will-fail-REGARDLESS-OF-ANYTHING-ELSE",
			  :description	=> "Real nigga shit",
			  :image_url	=> "zzz.jpg")

# sb: after creating a sample product above, test all possible values of price
# sb: think of calculus bounds....
# sb: the .valid and .invalid methods use the validates keyword from the model

    product.price = -1
    assert product.invalid?
    assert_equal "-1: must be >= 0.01", product.errors[:price].join('; ')

# sb: you can see above/below how it's more of BDD than TDD
# sb: is the price logic BEHAVING the way we intended?? 
# sb: rather than simply 'testing'.... BEHAVING >>>> testing...

    product.price = 0
    assert product.invalid?
    assert_equal "0: must be >= 0.01", product.errors[:price].join('; ') 

# sb: Why does the below still fail?
# sb: Previously failed because the product model used DID NOT
# sb: have a unique title, so this invalidated the whole product
# sb: even though all the price tests were OK
    product.price = 1
    assert product.valid?

#    product.price = 1.00
#    assert product.valid?
#    assert_equal "1.00: must be >= 0.01", product.errors[:price].join('; ') 

  end

#-------------------------------------------------------------------------------
# sb: here we display how we can write a common method 
  def new_product(image_url)
    Product.new(:title		=> "SoSym",
		:description	=> "sss",
		:price		=> 777,
		:image_url	=> image_url)
  end

# sb: then use loops in the actual test/do block for more efficacy
  test "image_url" do
    ok = %w{ fred.gif fred.jpg fred.png FRED.JPG FRED.Jpg
             http://a.b.c/x/y/z/fred.gif }
    bad = %w{ fred.doc fred.gif/more fred.gif.more }

    ok.each do |name|
      assert new_product(name).valid?, "Confirm #{name} tests valid"
    end

    bad.each do |name|
      assert new_product(name).invalid?, "Confirm #{name} tests invalid"
    end
  end
#-------------------------------------------------------------------------------
# sb: using fixtures ----> products(:ruby), i created as products(:tsd)
  test "product must have unique title" do
    product = Product.new(:title	=> products(:tsd).title,
                          :description	=> "brief description",
			  :price	=> 23.53,
			  :image_url	=> "unique_title.jpg")

    assert !product.save
#    assert_equal "already in use... choose another name", products.errors[:title].join('; ')
# sb: above hard-codes the active record error --- you can use below as alt.
    assert_equal I18n.translate('activerecord.errors.messages.taken'), product.errors[:title].join('; ')

  end



end
