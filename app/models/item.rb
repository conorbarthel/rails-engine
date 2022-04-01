class Item < ApplicationRecord
  belongs_to :merchant

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
