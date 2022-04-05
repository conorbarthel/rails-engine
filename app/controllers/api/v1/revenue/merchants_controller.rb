class Api::V1::Revenue::MerchantsController < ApplicationController
  def index
    if params[:quantity] == nil
      render json: { error: { data:"Parameter cannot be missing" } }, status: 400
    else
      merchants = Merchant.top_merchants_by_revenue(params[:quantity])
      render json: MerchantNameRevenueSerializer.new(merchants)
    end
  end
end
