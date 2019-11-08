class ListRenderer
  class << self
    def display(list)
      list.each_with_index do |li, index|
        puts "#{index + 1}. #{li}"
      end
    end
  end
end
