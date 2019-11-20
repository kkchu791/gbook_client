require "pstore"
require "byebug"

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

    def add(name, book)
      store.transaction do |store|

        if store[name].include?(book)
          raise "This book already exists in your #{humanize(name)}. Try adding another book"
        end

        store[name] = (store[name] || []).push(book)
      end
    end

    def delete(name, num)
      new_list = self.fetch(name)
      new_list.delete_at(num.to_i - 1)
      self.save(name, new_list)
    end

    private

    def humanize(name)
      name.split("_").join(" ")
    end

    def store
      @@store ||= PStore.new("/tmp/book.txt")
    end
  end
end
