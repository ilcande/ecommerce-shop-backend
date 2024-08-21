class Constraint < ApplicationRecord
  belongs_to :part
  belongs_to :constraint_part, class_name: 'Part'
  belongs_to :constraint_option, class_name: 'Option'

  validates :part, :constraint_part, :constraint_option, presence: true
end
