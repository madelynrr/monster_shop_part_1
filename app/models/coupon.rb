class Coupon < ApplicationRecord

  validates_presence_of :name, :code, :percentage
  validates_uniqueness_of :name, :code

  belongs_to :merchant

end
