require_relative '../lib/gbook_api.rb'
require "httparty"
require 'byebug'

describe 'GbookApi' do
  describe '#get' do
    context "when given a keyword" do
      it "returns a list of parsed books" do
        keyword = "war"
        response = HTTParty.get("https://www.googleapis.com/books/v1/volumes?q=#{keyword}&maxResults=5&partial=true")
        json = JSON.parse(response.body)
        result  = GbookApi.parse_books(json["items"])

        expect(GbookApi.get(keyword)).to eq(result)
      end
    end
  end
end
