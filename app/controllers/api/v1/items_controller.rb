class Api::V1::ItemsController < ApplicationController
  def index
    render json: ItemSerializer.new(Item.all)
  end

  def show
    render json: ItemSerializer.new(Item.find(params[:id]))
  end

  def create
    item = Item.create(item_params)
    render json: ItemSerializer.new(item), status: 201
  end

  def destroy
    render json: Item.delete(params[:id])
  end

  def update
    item = Item.find(params[:id])
    new_item = item.update(item_params)
    if item_params[:merchant_id].nil? || Merchant.exists?(item_params[:merchant_id])
      render json: ItemSerializer.new(item), status: 202
    else
      render json: { errors: { details: "item update unsuccessful" } },status: 400
    end
  end

  def find
    item = Item.search(params[:search]).first
    render json: ItemSerializer.new(item)
  end

  private
   def item_params
     params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
   end
end
