require "byebug"
require_relative '../lib/gbook.rb'

describe 'Gbook' do
  let(:gbook) { Gbook.new }
  let(:gbook_api) { GbookApi }
  let(:gbook_store) { GbookStore }
  let(:list_renderer) { ListRenderer }

  describe '#search' do
    before do
      allow(list_renderer).to receive(:display)
    end

    context 'when given a keyword' do
      it "delegates fetching list of books to gbook_api" do

        expect(gbook_api).to receive(:get).and_return(["list of books"])
        gbook.search("war")
      end

      it 'delegates saving of books to gbook_api' do
        expect(gbook_store).to receive(:save)
        gbook.search("war")
      end

      it 'delegates printing list of books to list_renderer' do
        expect(list_renderer).to receive(:display)
        gbook.search("war")
      end
    end
  end

  describe '#show' do
    before do
      allow(list_renderer).to receive(:display)
      allow(gbook_store).to receive(:fetch).and_return(["a book"])
      allow(gbook_api).to receive(:get)
    end

    it "delegates fetching search_results to gbook_store" do
      expect(gbook_store).to receive(:fetch)
      gbook.show
    end

    it 'delegates printing list of books to list_renderer' do
      expect(list_renderer).to receive(:display)
      gbook.show
    end

    context 'when search results are empty' do
      before do
        allow(gbook_store).to receive(:fetch).and_return([])
      end

      it 'prints out an error' do
        search_results_empty_error = "There are no search results yet. Perform a 'search' first."
        expect{ gbook.show }.to output{search_results_empty_error}.to_stdout
      end
    end
  end

  describe '#add' do
    context 'when given a valid index' do
      it 'delegates adding a book to store to gbook_store' do
        expect(gbook_store).to receive(:add)
        gbook.add(1)
      end
    end

    context 'when search results is empty' do
      before do
        gbook_store.save("search_results", [])
      end

      it 'prints out an error' do
        empty_search_error = "There are no search results yet. Perform a 'search' first."
        expect{gbook.add(1)}.to output{empty_search_error}.to_stdout
      end
    end

    context 'when given an out of range index' do
      before do
        gbook.search("war")
      end

      it 'prints out an error' do
        out_of_range_error = "Received book index 6, expected an index from (1..5)"
        expect{gbook.add(6)}.to output{out_of_range_error}.to_stdout
      end
    end

    context 'when given an non integer input' do
      it 'prints out an error' do
        non_integer_error = "Please enter a number from (1..5)"
        expect{gbook.add("test")}.to output{non_integer_error}.to_stdout
      end
    end

    context 'when given an index of a book already in our reading list' do
      it 'prints out an error' do
        duplicate_error = "This book already exists in your reading list. Try adding another book."
        expect{gbook.add(1)}.to output{duplicate_error}.to_stdout
      end
    end
  end

  describe '#delete' do
    context 'when given a valid index' do

      before do
        gbook.search("war")
        gbook.add(1)
      end

      it 'delegates deleting a book from store to gbook_store' do
        expect(gbook_store).to receive(:delete)
        gbook.delete(1)
      end
    end

    context 'when reading list is empty' do
      before do
        gbook_store.save("reading_list", [])
      end

      it 'prints out an error' do
        empty_reading_list_error = "Your reading list is currently empty. Try command 'add' to add a book first."
        expect{gbook.delete(1)}.to output{empty_reading_list_error}.to_stdout
      end
    end

    context 'when given an out of range index' do
      before do
        3.times { |index| gbook.add(index + 1) }
      end

      it 'prints out an error' do
        out_of_range_error = "Received book index 4, expected an index from (1..3)"
        expect{gbook.delete(4)}.to output{out_of_range_error}.to_stdout
      end
    end

    context 'when given an non integer input' do
      it 'prints out an error' do
        non_integer_error = "Please enter a number from (1..3)"
        expect{gbook.delete("test")}.to output{non_integer_error}.to_stdout
      end
    end
  end

  describe '#list' do
    before do
      allow(list_renderer).to receive(:display)
      gbook.add(1)
    end

    it 'delegates printing list of books to list_renderer' do
      expect(list_renderer).to receive(:display)
      gbook.list
    end

    context 'when list is empty' do
      before do
        gbook_store.save("reading_list", [])
      end

      it 'prints out an error' do
        list_empty_error = "Your reading list is currently empty. Try command 'add' to add a book first."
        expect{gbook.list}.to output{list_empty_error}.to_stdout
      end
    end
  end
end
