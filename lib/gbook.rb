require "thor"
require "byebug"
require_relative './gbook_api.rb'
require_relative './gbook_store.rb'
require_relative './list_renderer.rb'

class Gbook < Thor
  SEARCH_RESULTS = "search_results"
  READING_LIST = "reading_list"

  desc "search KEYWORD", "search for books in Google Books API by keyword"

  def search(keyword)
    list_of_books = GbookApi.get(keyword)
    GbookStore.save(SEARCH_RESULTS, list_of_books)
    ListRenderer.display(list_of_books)
  end

  desc "show", "show previous search result list"

  def show
    ListRenderer.display(search_results)
  end

  desc "add BOOK_INDEX", "add a new book to your reading list"

  def add(book_index)
    if search_results.empty?
      puts "There are no available books to add. Perform a 'search' first."
      return
    end

    return unless valid_index?(book_index, search_results)

    book = search_results[book_index.to_i - 1]
    GbookStore.add(READING_LIST, book)
  end

  desc "delete BOOK_INDEX", "remove a book from your reading list"

  def delete(book_index)
    if reading_list.empty?
      puts "There are no available book to delete. Add a book first."
      return
    end

    return unless valid_index?(book_index, reading_list)

    GbookStore.delete(READING_LIST, book_index.to_i)
  end

  desc "list", "list all your books in your reading list"

  def list
    ListRenderer.display(reading_list)
  end

  private

  def valid_index?(book_index, store)
    begin
      book_index = Integer(book_index)
    rescue
      puts "Please enter a number from (1..#{store.length})"
      return false
    end

    unless (1..store.length).include?(book_index)
      puts "Received book index #{book_index}, expected an index from (1..#{store.length})"
      return false
    end

    true
  end

  def reading_list
    @reading_list ||= GbookStore.fetch(READING_LIST)
  end

  def search_results
    @search_results ||= GbookStore.fetch(SEARCH_RESULTS)
  end
end

Gbook.start(ARGV)
