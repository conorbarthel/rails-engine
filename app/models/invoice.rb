class Invoice < ApplicationRecord
  belongs_to :customer
  has_many :transactions
  has_many :invoice_items
  has_many :items, through: :invoice_items
  has_many :merchants, through: :items

  def self.revenue_by_invoice_date(start_date, end_date)
    Invoice.joins(:invoice_items, :transactions)
    .where(transactions: { result: 'success'}, invoices: { status: 'shipped'})
    .where("invoices.created_at >=?", "#{start_date}")
    .where("invoices.created_at <=?", "#{end_date}")
    .select('SUM(invoice_items.quantity*invoice_items.unit_price) AS revenue')
    .first
  end
end
