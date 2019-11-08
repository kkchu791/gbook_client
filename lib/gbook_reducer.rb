require "pstore"

class GbookReducer
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
      book = self.fetch("search_results")[num.to_i - 1]

      store.transaction do |store|
        store[name] = (store[name] || []).push(book)
      end
    end

    def delete(name, num)
      new_list = self.fetch(name)
      new_list.delete_at(num.to_i - 1)
      self.save(name, new_list)
    end

    private

    def store
      @@store ||= PStore.new("/tmp/book.txt")
    end
  end
end
