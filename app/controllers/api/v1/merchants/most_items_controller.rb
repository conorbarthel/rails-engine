class Api::V1::Merchants::MostItemsController < ApplicationController
  def index
    if params[:quantity] == nil
      render json: { error: { data:"Parameter cannot be missing" } }, status: 400
    elsif params[:quantity].to_i.class != Integer
      render json: { error: { data:"Parameter must be ineger" } }, status: 400
    else
      merchants = Merchant.top_merchants_by_items_sold(params[:quantity])
      render json: MerchantItemsSoldSerializer.new(merchants)
    end
  end
end
