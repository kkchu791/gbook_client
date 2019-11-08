require_relative '../lib/gbook_api.rb'
require "httparty"
require 'byebug'

describe 'GbookApi' do
  describe '#get' do
    context "when given a keyword" do
      it "returns a list of parsed books" do
        keyword = "war"
        result = [{"author"=>"Peter Bostrom", "title"=>"The Last War", "publisher"=>"Createspace Independent Publishing Platform"}, {"author"=>"Antony Beevor", "title"=>"The Second World War", "publisher"=>"Back Bay Books"}, {"author"=>"Carl von Clausewitz", "title"=>"On War", "publisher"=>"Princeton University Press"}, {"author"=>"P. W. SingerEmerson T. Brooking", "title"=>"LikeWar", "publisher"=>"Houghton Mifflin Harcourt"}, {"author"=>"Michael Beschloss", "title"=>"Presidents of War", "publisher"=>"Crown"}]

        expect(GbookApi.get(keyword)).to eq(result)
      end
    end
  end

  describe '#parse_books' do
    context "when given a list of books" do
      it "returns a list of parsed books" do
        response = HTTParty.get("https://www.googleapis.com/books/v1/volumes?q=war&maxResults=5&partial=true")
        json = JSON.parse(response.body)
        list = [json["items"][0]]
        parsed_list = [{"author"=>"Peter Bostrom", "title"=>"The Last War", "publisher"=>"Createspace Independent Publishing Platform"}]
        expect(GbookApi.parse_books(list)).to eq(parsed_list)
      end
    end
  end
end
