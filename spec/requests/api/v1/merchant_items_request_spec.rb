require 'rails_helper'

describe "Merchant items API" do
  it "sends a list of merchant items" do
    merch = create(:merchant)
    items = create_list(:item, 5, merchant: merch)

    get api_v1_merchant_items_path(merch)

    expect(response).to be_successful

    merchant_items = JSON.parse(response.body, symbolize_names: true)

    expect(merchant_items[:data].count).to eq(3)
    merchant_item = merchant_items[:data].first

    expect(merchant_item).to have_key(:id)
    expect(merchant_item[:id]).to be_an(String)

    expect(merchant_item[:attributes]).to have_key(:name)
    expect(merchant_item[:attributes][:name]).to be_a(String)

    expect(merchant_item[:attributes]).to have_key(:description)
    expect(merchant_item[:attributes][:description]).to be_a(String)

    expect(merchant_item[:attributes]).to have_key(:unit_price)
    expect(merchant_item[:attributes][:unit_price]).to be_a(String)
  end
end
