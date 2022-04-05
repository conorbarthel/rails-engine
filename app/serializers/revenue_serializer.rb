class RevenueSerializer
  def self.format_revenue(revenue)
    {
      "data": revenue.each do |variable|
        {
          "id": variable.id,
          "attributes": {
            "revenue": variable.revenue
          }
        }
      end
    }

  end
end
