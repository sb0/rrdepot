module ApplicationHelper
  def hidden_div_if(condition, attributes={}, &block)
# sb: the view passes the :id attribute already
#    attributes["id"] = "cart"
    if condition
       attributes["style"] = "display: none"
    end
    content_tag("div", attributes, &block)
  end
end
