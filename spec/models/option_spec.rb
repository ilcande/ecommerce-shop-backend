require 'rails_helper'

RSpec.describe Option, type: :model do
  it { should belong_to(:part) }
  it { should have_many(:stock_levels) }
  it { should have_many(:product_configurations) }
  it { should have_many(:constraints).with_foreign_key(:constraint_option_id) }

  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:price) }
  it { should validate_numericality_of(:price).is_greater_than_or_equal_to(0) }
  it { should validate_presence_of(:part) }
end
