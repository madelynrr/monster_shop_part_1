require 'rails_helper'

RSpec.describe MerchantOrder, type: :model do
  describe 'relationships' do
    it { should belong_to :merchant }
    it { should belong_to :order }
  end
end