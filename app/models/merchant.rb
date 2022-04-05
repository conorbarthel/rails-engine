class Merchant < ApplicationRecord
  has_many :items
  has_many :invoices
  has_many :transactions, through: :invoices
  has_many :customers, through: :invoices
  has_many :invoice_items, through: :invoices

  def self.top_merchants_by_revenue(number)
    Merchant.joins(invoices: [:invoice_items, :transactions])
    .where(transactions: { result: 'success'}, invoices: { status: 'shipped'})
    .group('merchants.id')
    .select('merchants.*, SUM(invoice_items.quantity*invoice_items.unit_price) AS revenue')
    .order('revenue DESC')
    .limit(number)
  end

  def self.top_merchants_by_items_sold(number)
    Merchant.joins(invoices: [:invoice_items, :transactions])
    .where(transactions: { result: 'success'}, invoices: { status: 'shipped'})
    .group('merchants.id')
    .select("merchants.*, Sum(invoice_items.quantity) AS items_sold")
    .order('items_sold DESC')
    .limit(number)
  end

  
end
