class PriceModifier < ApplicationRecord
  belongs_to :product
  has_many :price_modifier_conditions, dependent: :destroy
  has_many :options, through: :price_modifier_conditions

  validates :modifier_amount, numericality: { greater_than_or_equal_to: 0 }
end
