class Api::V1::MerchantsController < ApplicationController
  def index
    render json: MerchantSerializer.new(Merchant.all)
  end

  def show
    render json: MerchantSerializer.new(Merchant.find(params[:id]))
  end

  def find_all
    if params[:name] == nil
      render json: { data: { error:"Parameter cannot be missing" } }, status: 400
    else
      merchant = Merchant.search(params[:name])
      if merchant != []
        render json: MerchantSerializer.new(merchant)
      else
        render json: { data: { error:"No merchant data" } }, status: 400
      end
    end
  end
end
