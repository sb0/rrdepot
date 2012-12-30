require 'test_helper'

class NotifierTest < ActionMailer::TestCase
  test "order_received" do
    mail = Notifier.order_received(orders(:four))
    assert_equal "Your order from RRD has been received", mail.subject
    assert_equal ["hiphophe@gmail.com"], mail.to
    assert_equal ["orders@rrdepot.local"], mail.from
    # sb: assert_match Product.title [quantity]
    assert_match "/Sit in Dark Tee [1]/", mail.body.encoded
  end

  test "order_shipped" do
    mail = Notifier.order_shipped(orders(:four))
    assert_equal "Your order from RRD has been shipped", mail.subject
    assert_equal ["hiphophe@gmail.com"], mail.to
    assert_equal ["orders@rrdepot.local"], mail.from
    # sb: assert_match Product.title [quantity]
    assert_match "/<td>Sit in Dark Tee<\/td><td>[1]<\/td>\s*/", mail.body.encoded
  end

end
