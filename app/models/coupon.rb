class Coupon < ApplicationRecord

  validates_presence_of :name, :code, :percentage
  validates_uniqueness_of :name, :code
  validates_inclusion_of :percentage, in: 1..100, message: "needs to be between 1 and 100."

  belongs_to :merchant

end
