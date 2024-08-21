require 'rails_helper'

RSpec.describe ProductConfiguration, type: :model do
  it { should belong_to(:product) }
  it { should belong_to(:option) }

  it { should validate_presence_of(:product) }
  it { should validate_presence_of(:option) }
end
