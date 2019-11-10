require "thor"
require "byebug"
require_relative './gbook_api.rb'
require_relative './gbook_store.rb'
require_relative './list_renderer.rb'

class Gbook < Thor
  desc "search KEYWORD", "search for books in Google Books API by keyword"

  def search(keyword)
    list_of_books = GbookApi.get(keyword)
    GbookStore.save("search_results", list_of_books)
    ListRenderer.display(list_of_books)
  end

  desc "show", "show previous search result list"

  def show
    list_of_books = GbookStore.fetch("search_results")
    ListRenderer.display(list_of_books)
  end

  desc "add NUM", "add a new book to your reading list"

  def add(num)
    GbookStore.add("reading_list", num.to_i)
  end

  desc "delete NUM", "remove a book from your reading list"

  def delete(num)
    GbookStore.delete("reading_list", num.to_i)
  end

  desc "list", "list all your books in your reading list"

  def list
    list_of_books = GbookStore.fetch("reading_list")
    ListRenderer.display(list_of_books)
  end
end

Gbook.start(ARGV)
