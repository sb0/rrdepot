class User < ActiveRecord::Base
  attr_accessible :name, :passwd, :salt
end
