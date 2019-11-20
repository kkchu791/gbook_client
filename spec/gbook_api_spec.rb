require_relative '../lib/gbook_api.rb'
require "httparty"
require 'byebug'

describe 'GbookApi' do
  describe '#get' do
    context "when given a keyword and results are found" do
      it "returns a list of parsed books" do
        keyword = "war"
        response = HTTParty.get("https://www.googleapis.com/books/v1/volumes?q=#{keyword}&maxResults=5&partial=true")
        json = JSON.parse(response.body)
        result  = GbookApi.parse_books(json["items"])

        expect(GbookApi.get(keyword)).to eq(result)
      end
    end

    context "when given a keyword and no results are found" do
      it "raises an error" do
        keyword = "ajkdfbhjkdasbf"
        expect { GbookApi.get(keyword) }.to raise_error("No results found for that keyword.")
      end
    end

    context 'when given an invalid keyword' do
      it 'prints out an error' do
        invalid_keyword_error = "You must provide a full keyword."
        expect{ GbookApi.get("       ")}.to raise_error(invalid_keyword_error)
      end
    end
  end
end
