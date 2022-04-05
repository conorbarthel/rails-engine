class Item < ApplicationRecord
  belongs_to :merchant
  has_many :invoice_items, dependent: :destroy
  has_many :invoices, through: :invoice_items
  has_many :transactions, through: :invoices

  def self.min_price(item)
    where("unit_price >= ?", "#{item.unit_price}")
    .order(:unit_price)
    .first
  end

  def self.max_price(item)
    where("unit_price <= ?", "#{item.unit_price}")
    order(:unit_price)
    .last
  end
end
