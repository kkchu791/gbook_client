require_relative '../lib/gbook_reducer.rb'
require 'byebug'

describe 'GbookReducer' do
  describe '#fetch' do
    context "when given a name of a store" do
      it "returns the correct data" do
        past_search_list = [{"author"=>"Peter Bostrom", "title"=>"The Last War", "publisher"=>"Createspace Independent Publishing Platform"}]
        store = PStore.new("/tmp/book.txt")
        store.transaction { |store| store["past_search"] = past_search_list }
        expect(GbookReducer.fetch("past_search")).to eq(past_search_list)
      end
    end
  end

  describe '#save' do
    context "when given a name and data" do
      it "should store store data and name as a key value pair in our persistent stores" do
        reading_list = [{"author"=>"Jac Milon", "title"=>"World War II", "publisher"=>"Crown Publishing Co."}]
        GbookReducer.save("reading_list", reading_list)
        expect(GbookReducer.fetch("reading_list")).to eq(reading_list)
      end
    end
  end

  describe '#add' do
    context "when given a name and a book identifier number" do
      it "adds the correct book from our past_search list to our named store" do
        expect{GbookReducer.add("reading_list", 1)}.to change{GbookReducer.fetch("reading_list").count}.by(1)
      end
    end
  end

  describe '#delete' do
    context "when given a name and a book identifier number" do
      it "deletes the correct book from our named store" do
        second_book_on_reading_list = {"author"=>"Peter Bostrom", "title"=>"The Last War", "publisher"=>"Createspace Independent Publishing Platform"}
        expect(GbookReducer.fetch("reading_list")).to include(second_book_on_reading_list)
        expect{GbookReducer.delete("reading_list", 2)}.to change{GbookReducer.fetch("reading_list").count}.by(-1)
        expect(GbookReducer.fetch("reading_list")).not_to include(second_book_on_reading_list)
      end
    end
  end
end
