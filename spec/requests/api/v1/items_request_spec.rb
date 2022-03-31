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

  it "can create a new item" do
    merch = create(:merchant)
    item_params = ({
                    name: 'Photo Album',
                    description: 'photos',
                    unit_price: 999,
                    merchant_id: 5
                  })
    headers = {"CONTENT_TYPE" => "application/json"}

    post "/api/v1/items", headers: headers, params: JSON.generate(item: item_params)

    created_item = Item.last

    expect(response).to be_successful
    expect(created_item.name).to eq(item_params[:name])
    expect(created_item.description).to eq(item_params[:description])
    expect(created_item.unit_price).to eq(item_params[:unit_price])
    expect(created_item.merchant_id).to eq(item_params[:merchant_id])
  end

  it "can destroy an item" do
    merch = create(:merchant)
    item = create(:item, merchant: merch)

    expect(Item.count).to eq(1)

    delete "/api/v1/items/#{item.id}"

    expect(response).to be_successful
    expect(Item.count).to eq(0)
    expect{Item.find(item.id)}.to raise_error(ActiveRecord::RecordNotFound)
  end

  it "can update an existing item" do
    merch = create(:merchant)
    item = create(:item, merchant: merch)
    previous_name = Item.last.name
    item_params = { name: "New Item" }
    headers = {"CONTENT_TYPE" => "application/json"}

    patch "/api/v1/items/#{item.id}", headers: headers, params: JSON.generate({item: item_params})
    item = Item.find_by(id: item.id)

    expect(response).to be_successful
    expect(item.name).to_not eq(previous_name)
    expect(item.name).to eq("New Item")
  end

  it "can't update an item with a merchant id that doesn't exist" do
    merch = create(:merchant)
    item = create(:item, merchant: merch)
    previous_name = Item.last.name
    item_params = { name: "New Item", merchant_id: 555}
    headers = {"CONTENT_TYPE" => "application/json"}

    patch "/api/v1/items/#{item.id}", headers: headers, params: JSON.generate({item: item_params})
    item = Item.find_by(id: item.id)

    expect(response.status).to eq(400)
    expect(item.name).to eq(previous_name)
    expect(item.name).to_not eq("New Item")
  end

  it "can get an item's merchant" do
    merch = create(:merchant)
    item = create(:item, merchant: merch)

    get api_v1_item_merchant_index_path(item)

    merchant = JSON.parse(response.body, symbolize_names: true)
    merchant = merchant[:data]
    expect(merchant).to have_key(:id)
    expect(merchant[:id]).to be_an(String)

    expect(merchant[:attributes]).to have_key(:name)
    expect(merchant[:attributes][:name]).to be_a(String)
    expect{get api_v1_item_merchant_index_path("209")}.to raise_error(ActiveRecord::RecordNotFound)
  end

  it "can search for items and return up to one item with
  search terms in alphebetical order" do
    merch = create(:merchant)
    item = Item.create!(name: "Mouse",
                  description: "Cursor",
                  unit_price: 9599,
                  merchant_id: merch.id)
    not_item = Item.create!(name: "keys",
                  description: "board",
                  unit_price: 12599,
                  merchant_id: merch.id)
    item2 = Item.create!(name: "ze Mouse",
                  description: "Cursor",
                  unit_price: 9899,
                  merchant_id: merch.id)
    search = "mouse"

    get api_v1_items_find_path(name: search)

    item_response = JSON.parse(response.body, symbolize_names: true)

    item_data = item_response[:data]

    expect(item_data[:attributes][:name]).to eq("Mouse")
    expect(item_data[:attributes][:name]).to_not eq("keys")
    expect(item_data[:attributes][:name]).to_not eq("Mouse 2")
    expect(item_response.count).to eq(1)
  end

  it "returns an error message when no search results are found" do
    merch = create(:merchant)
    item = Item.create!(name: "Mouse",
                  description: "Cursor",
                  unit_price: 9599,
                  merchant_id: merch.id)
    not_item = Item.create!(name: "keys",
                  description: "board",
                  unit_price: 12599,
                  merchant_id: merch.id)
    item2 = Item.create!(name: "Mouse 2",
                  description: "Cursor",
                  unit_price: 9899,
                  merchant_id: merch.id)
    search = "cat"

    get api_v1_items_find_path(name: search)

    item_response = JSON.parse(response.body, symbolize_names: true)

    expect(response.status).to eq(200)
    expect(item_response[:data][:error]).to eq("No item data")
  end

  it "returns an error message when no search results are input" do
    merch = create(:merchant)
    item = Item.create!(name: "Mouse",
                  description: "Cursor",
                  unit_price: 9599,
                  merchant_id: merch.id)
    not_item = Item.create!(name: "keys",
                  description: "board",
                  unit_price: 12599,
                  merchant_id: merch.id)
    item2 = Item.create!(name: "Mouse 2",
                  description: "Cursor",
                  unit_price: 9899,
                  merchant_id: merch.id)
    search = nil

    get api_v1_items_find_path(name: search)

    item_response = JSON.parse(response.body, symbolize_names: true)

    expect(response.status).to eq(200)
    expect(item_response[:data][:error]).to eq("Parameter cannot be missing")
  end
end
