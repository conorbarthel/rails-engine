require 'rails_helper'

describe "Merchants API" do
  it "sends a list of merchants" do
    create_list(:merchants, 3)

    get '/api/v1/merchantss'

    expect(response).to be_successful

    merchantss = JSON.parse(response.body, symbolize_names: true)

    expect(merchantss.count).to eq(3)
  end
end
