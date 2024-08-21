class Part < ApplicationRecord
  has_many :options, dependent: :destroy
  has_many :constraints, dependent: :destroy, foreign_key: :part_id
  has_many :constraint_parts, through: :constraints, source: :constraint_part

  validates :name, :product_type, presence: true
end
