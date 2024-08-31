class Option < ApplicationRecord
  belongs_to :part
  has_many :stock_levels
  has_many :product_configurations
  has_many :constraints, foreign_key: :constraint_option_id

  validates :name, :price, :part, presence: true, uniqueness: { scope: :part_id }
  validates :price, numericality: { greater_than_or_equal_to: 0 }
end
