class Product < ApplicationRecord
  has_many :product_configurations, dependent: :destroy
  has_many :options, through: :product_configurations

  validates :name, :product_type, :base_price, presence: true
  validates :base_price, numericality: { greater_than_or_equal_to: 0 }
end
