require 'rails_helper'

describe "Merchants API" do
  it "sends a list of merchants" do
    create_list(:merchant, 3)

    get '/api/v1/merchants'

    expect(response).to be_successful

    merchants = JSON.parse(response.body, symbolize_names: true)

    expect(merchants[:data].count).to eq(3)
    merchant = merchants[:data].first

    expect(merchant).to have_key(:id)
    expect(merchant[:id]).to be_an(String)

    expect(merchant[:attributes]).to have_key(:name)
    expect(merchant[:attributes][:name]).to be_a(String)
  end

  it "can get one merchant by its id" do
    id = create(:merchant).id

    get "/api/v1/merchants/#{id}"

    merchant = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful
    merchant_data = merchant[:data]

    expect(merchant_data).to have_key(:id)
    expect(merchant_data[:id]).to eq("#{id}")

    expect(merchant_data[:attributes]).to have_key(:name)
    expect(merchant_data[:attributes][:name]).to be_a(String)
  end

  it "returns an error response when merchant is not found" do
    id = 999

    expect{get "/api/v1/merchants/#{id}"}.to raise_error(ActiveRecord::RecordNotFound)
  end

  it "can search for and find all merchants matching a partial search
  and return them alphebeticaly" do
    merchant1 = Merchant.create!(name: "Strause")
    merchant2 = Merchant.create!(name: "Strause farms")
    merchant3 = Merchant.create!(name: "stRAuSe Farmz")
    not_merchant = Merchant.create!(name: "something else")
    search = "rause"

    get api_v1_merchants_find_all_path(name: search)
    merchant_response = JSON.parse(response.body, symbolize_names: true)
    merchant_data = merchant_response[:data]

    expect(merchant_data.count).to eq(3)
    expect(merchant_data.first[:attributes][:name]).to eq("Strause")
    expect(merchant_data.last[:attributes][:name]).to eq("stRAuSe Farmz")
  end
end
