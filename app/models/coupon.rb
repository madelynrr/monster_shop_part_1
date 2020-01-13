class Coupon < ApplicationRecord

  validates_presence_of :name, :code, :percentage

end
