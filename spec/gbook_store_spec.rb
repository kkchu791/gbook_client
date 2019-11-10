require_relative '../lib/gbook_store.rb'
require 'byebug'

describe 'GbookStore' do
  describe '#fetch' do
    context "when given a name of a store" do
      it "returns the correct data" do
        search_results_list = [{"author"=>"Peter Bostrom", "title"=>"The Last War", "publisher"=>"Createspace Independent Publishing Platform"}]
        store = PStore.new("/tmp/book.txt")
        store.transaction { |store| store["search_results"] = search_results_list }
        expect(GbookStore.fetch("search_results")).to eq(search_results_list)
      end
    end
  end

  describe '#save' do
    context "when given a name and data" do
      it "should store store data and name as a key value pair in our persistent stores" do
        reading_list = [{"author"=>"Jac Milon", "title"=>"World War II", "publisher"=>"Crown Publishing Co."}]
        GbookStore.save("reading_list", reading_list)
        expect(GbookStore.fetch("reading_list")).to eq(reading_list)
      end
    end
  end

  describe '#add' do
    context "when given a name and a book identifier number" do
      it "adds the correct book from our search_results list to our named store" do
        expect{GbookStore.add("reading_list", 1)}.to change{GbookStore.fetch("reading_list").count}.by(1)
      end
    end

    context "when a search hasn't been made" do
      it "prints out an error message" do
        GbookStore.save("search_results", nil)
        error_message = "Nothing in search result to add. Please search for something first."
        expect{GbookStore.add("reading_list", 1)}.to output{error_message}.to_stdout
      end
    end

    context "when an invalid number is given" do
      it "prints out an error message" do
        error_message = "Please enter a valid number."
        expect{GbookStore.add("reading_list", 0)}.to output{error_message}.to_stdout
      end
    end
  end

  describe '#delete' do
    context "when given a name and a book identifier number" do
      it "deletes the correct book from our named store" do
        first_book_on_reading_list = GbookStore.fetch("reading_list")[0]
        expect(GbookStore.fetch("reading_list")).to include(first_book_on_reading_list)
        expect{GbookStore.delete("reading_list", 1)}.to change{GbookStore.fetch("reading_list").count}.by(-1)
        expect(GbookStore.fetch("reading_list")).not_to include(first_book_on_reading_list)
      end
    end

    context "when a search hasn't been made" do
      it "prints out an error message" do
        GbookStore.save("reading_list", nil)
        error_message = "Nothing in reading list to delete. Please add something first."
        expect{GbookStore.delete("reading_list", 1)}.to output{error_message}.to_stdout
      end
    end

    context "when an invalid number is given" do
      it "prints out an error message" do
        error_message = "Please enter a valid number."
        expect{GbookStore.delete("reading_list", 0)}.to output{error_message}.to_stdout
      end
    end
  end
end
