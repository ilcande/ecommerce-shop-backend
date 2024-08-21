require 'rails_helper'

RSpec.describe Part, type: :model do
  it { should have_many(:options).dependent(:destroy) }
  it { should have_many(:constraints).dependent(:destroy) }
  it { should have_many(:constraint_parts).through(:constraints).source(:constraint_part) }

  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:product_type) }
end
