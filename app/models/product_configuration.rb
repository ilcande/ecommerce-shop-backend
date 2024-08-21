class ProductConfiguration < ApplicationRecord
  belongs_to :product
  belongs_to :option

  validates :product, :option, presence: true
end
