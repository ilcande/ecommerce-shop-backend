class PriceModifierCondition < ApplicationRecord
  belongs_to :price_modifier
  belongs_to :option

  validates :price_modifier, :option, presence: true
end
