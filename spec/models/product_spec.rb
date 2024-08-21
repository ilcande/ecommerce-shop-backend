require 'rails_helper'

RSpec.describe Product, type: :model do
  it { should have_many(:product_configurations).dependent(:destroy) }
  it { should have_many(:options).through(:product_configurations) }

  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:product_type) }
  it { should validate_presence_of(:base_price) }
  it { should validate_numericality_of(:base_price).is_greater_than_or_equal_to(0) }
end
