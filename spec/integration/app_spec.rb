require 'spec_helper'

describe 'core gateway function' do
  include Rack::Test::Methods

  it "returns 200 with valid json" do
    post '/gateway/v1/big_commerce/new_order', Oj.load(File.open("spec/fixtures/valid_json.json")).to_json
    expect(last_response.status).to eq 200
    expect(last_response.body).to eq('')
  end

  it "returns 422 with valid json" do
    post '/gateway/v1/big_commerce/new_order', File.read("spec/fixtures/bad_json.json")
    expect(last_response.status).to eq 422
    expect(last_response.body).to eq('')
  end

  it "returns 404 with valid json to invalid endpoint" do
    post '/gateway/v1/big_commerce/new_stupid', Oj.load(File.open("spec/fixtures/valid_json.json")).to_json
    expect(last_response.status).to eq 404
    expect(last_response.body).to eq('')
  end

  it "returns 500 when RabbitMQ has gone away" do
    pending
    post '/gateway/v1/big_commerce/new_stupid', Oj.load(File.open("spec/fixtures/valid_json.json")).to_json
    expect(last_response.status).to eq 404
    expect(last_response.body).to eq('')
  end
end
