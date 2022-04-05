class Api::V1::RevenueController < ApplicationController
  def index
    if params[:start] == nil || params[:end] == nil
      render json: { error: { data:"Parameter cannot be missing" } }, status: 400
    else
      revenue = Invoice.revenue_by_invoice_date(params[:start], params[:end])
      render json: RevenueSerializer.format_revenue(revenue)
    end
  end
end
