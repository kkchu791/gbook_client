require "pstore"

class GbookStore
  class << self

    def fetch(name)
      store.transaction { |store| store[name] || [] }
    end

    def save(name, data = [])
      store.transaction do |store|
        store[name] = data
      end
    end

    def add(name, num)
      if self.fetch("search_results").empty?
        puts "Nothing in search result to add. Please search for something first."
        return
      end

      unless is_valid?(num)
        puts "Please enter a valid number"
        return
      end

      book = self.fetch("search_results")[num.to_i - 1]

      store.transaction do |store|
        store[name] = (store[name] || []).push(book)
      end
    end

    def delete(name, num)
      if self.fetch("reading_list").empty?
        puts "Nothing in reading list to delete. Please add something first."
        return
      end

      unless is_valid?(num)
        puts "Please enter a valid number"
        return
      end

      new_list = self.fetch(name)
      new_list.delete_at(num.to_i - 1)
      self.save(name, new_list)
    end

    private

    def is_valid?(num)
      within_range?(num) && num.is_a?(Integer)
    end

    def within_range?(num)
      num > 0 && num <= 5
    end

    def store
      @@store ||= PStore.new("/tmp/book.txt")
    end
  end
end
