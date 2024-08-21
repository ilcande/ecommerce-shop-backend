require 'rails_helper'

RSpec.describe StockLevel, type: :model do
  it { should belong_to(:option) }

  it { should validate_numericality_of(:quantity).is_greater_than_or_equal_to(0) }
end
