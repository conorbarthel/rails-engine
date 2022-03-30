require 'rails_helper'

describe "Items API" do
  it "sends a list of items" do
    merch = create(:merchant)
    mo_merch = create(:merchant)
    items = create_list(:item, 5, merchant: merch)
    mo_items = create_list(:item, 5, merchant: mo_merch)

    get api_v1_items_path

    expect(response).to be_successful

    items = JSON.parse(response.body, symbolize_names: true)

    expect(items[:data].count).to eq(10)
    item = items[:data].first

    expect(item).to have_key(:id)
    expect(item[:id]).to be_an(String)

    expect(item[:attributes]).to have_key(:name)
    expect(item[:attributes][:name]).to be_a(String)

    expect(item[:attributes]).to have_key(:description)
    expect(item[:attributes][:description]).to be_a(String)

    expect(item[:attributes]).to have_key(:unit_price)
    expect(item[:attributes][:unit_price]).to be_an(Float)

    expect(item[:attributes]).to have_key(:merchant_id)
    expect(item[:attributes][:merchant_id]).to be_an(Integer)
  end

  it "can get one item by its id" do
    merch = create(:merchant)
    mo_merch = create(:merchant)
    items = create_list(:item, 5, merchant: merch)
    mo_items = create_list(:item, 5, merchant: mo_merch)
    item = items.first

    get api_v1_item_path(item)

    item = JSON.parse(response.body, symbolize_names: true)
    item = item[:data]

    expect(item).to have_key(:id)
    expect(item[:id]).to be_an(String)

    expect(item[:attributes]).to have_key(:name)
    expect(item[:attributes][:name]).to be_a(String)

    expect(item[:attributes]).to have_key(:description)
    expect(item[:attributes][:description]).to be_a(String)

    expect(item[:attributes]).to have_key(:unit_price)
    expect(item[:attributes][:unit_price]).to be_an(Float)

    expect(item[:attributes]).to have_key(:merchant_id)
    expect(item[:attributes][:merchant_id]).to be_an(Integer)
  end
end
