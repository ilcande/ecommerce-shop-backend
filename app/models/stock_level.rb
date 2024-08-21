class StockLevel < ApplicationRecord
  belongs_to :option

  validates :quantity, numericality: { greater_than_or_equal_to: 0 }
  validates :is_in_stock, inclusion: { in: [true, false] }
end
