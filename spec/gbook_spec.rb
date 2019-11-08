require "byebug"
require_relative '../lib/gbook.rb'

describe 'Gbook' do
  let(:gbook) { Gbook.new }
  let(:gbook_api) { GbookApi }
  let(:gbook_reducer) { GbookReducer }
  let(:list_renderer) { ListRenderer }

  describe '#search' do

    before do
      allow(list_renderer).to receive(:display)
    end

    context 'when given a keyword' do
      it "delegates fetching list of books to gbook_api" do

        expect(gbook_api).to receive(:get)
        gbook.search("war")
      end

      it 'delegates saving of books to gbook_api' do
        expect(gbook_reducer).to receive(:save)
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
    end

    it "delegates fetching search_results to gbook_reducer" do
      expect(gbook_reducer).to receive(:fetch)
      gbook.show
    end

    it 'delegates printing list of books to list_renderer' do
      expect(list_renderer).to receive(:display)
      gbook.show
    end
  end

  describe '#add' do
    it 'delegates adding a book to store to gbook_reducer' do
      expect(gbook_reducer).to receive(:add)
      gbook.add(1)
    end
  end

  describe '#delete' do
    it 'delegates deleting a book from store to gbook_reducer' do
      expect(gbook_reducer).to receive(:delete)
      gbook.delete(1)
    end
  end

  describe '#list' do
    before do
      allow(list_renderer).to receive(:display)
    end

    it 'delegates fetching reading_list to gbook_reducer' do
      expect(gbook_reducer).to receive(:fetch)
      gbook.list
    end

    it 'delegates printing list of books to list_renderer' do
      expect(list_renderer).to receive(:display)
      gbook.list
    end
  end
end
