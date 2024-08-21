require 'rails_helper'

RSpec.describe Constraint, type: :model do
  it { should belong_to(:part) }
  it { should belong_to(:constraint_part).class_name('Part') }
  it { should belong_to(:constraint_option).class_name('Option') }

  it { should validate_presence_of(:part) }
  it { should validate_presence_of(:constraint_part) }
  it { should validate_presence_of(:constraint_option) }
end
