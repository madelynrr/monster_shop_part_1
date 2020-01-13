class Coupon < ApplicationRecord

  validates_presence_of :name, :code, :percentage

  belongs_to :merchant

end
