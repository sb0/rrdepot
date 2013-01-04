class Product < ActiveRecord::Base
  default_scope :order => 'title'
  attr_accessible :description, :image_url, :price, :title
  has_many :line_items
  has_many :orders, :through => :line_items
  validates :title, :uniqueness => true
  validates :price, :numericality => {:greater_than_or_equal_to => 0.01}
  validates :image_url, :format => {
            :with 	=> %r{\.(gif|jpg|png)$}i,
	    :message	=> 'must be a URL for GIF, JPG or PNG image.'
  }

  private
  
    def ensure_not_referenced_by_any_line_item
      if line_items.empty?
        return true
      else
        errors.add(:base, 'Line items present!')
        return false
      end
    end
end
