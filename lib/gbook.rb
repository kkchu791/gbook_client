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
  rescue => e
    puts e.message
  end

  desc "show", "show previous search result list"

  def show
    return if search_results_empty?
    ListRenderer.display(search_results)
  end

  desc "add BOOK_INDEX", "add a new book to your reading list"

  def add(book_index)
    return if search_results_empty?
    return if invalid_index?(book_index, search_results)
    book = search_results[book_index.to_i - 1]
    GbookStore.add(READING_LIST, book)
    puts "'#{book['title']} by #{book['author']}' was added to your reading list. Try command 'list' to check it out."
  rescue => e
    puts e.message
  end

  desc "delete BOOK_INDEX", "remove a book from your reading list"

  def delete(book_index)
    return if reading_list_empty?
    return if invalid_index?(book_index, reading_list)
    book = reading_list[book_index.to_i - 1]
    GbookStore.delete(READING_LIST, book_index.to_i)
    puts "'#{book['title']} by #{book['author']}' was deleted from your reading list. Try command 'list' to check it out."
  end

  desc "list", "list all your books in your reading list"

  def list
    return if reading_list_empty?
    ListRenderer.display(reading_list)
  end

  private

  def search_results_empty?
    if search_results.empty?
      puts "There are no search results yet. Perform a 'search' first."
      return true
    end

    false
  end

  def reading_list_empty?
    if reading_list.empty?
      puts "Your reading list is currently empty. Try command 'add' to add a book first."
      return true
    end

    false
  end

  def invalid_index?(book_index, store)
    begin
      book_index = Integer(book_index)
    rescue
      puts "Please enter a number from (1..#{store.length})"
      return true
    end

    unless (1..store.length).include?(book_index)
      puts "Received book index #{book_index}, expected an index from (1..#{store.length})"
      return true
    end

    false
  end

  def reading_list
    GbookStore.fetch(READING_LIST)
  end

  def search_results
    GbookStore.fetch(SEARCH_RESULTS)
  end
end

Gbook.start(ARGV)
