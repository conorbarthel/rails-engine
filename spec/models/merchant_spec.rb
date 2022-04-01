require 'rails_helper'

RSpec.describe Merchant, type: :model do
  describe 'relationships' do
    it { have_many(:items) }
  end
end
