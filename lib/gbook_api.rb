require "httparty"

class GbookApi
  class << self

    def get(keyword)
      response = HTTParty.get("https://www.googleapis.com/books/v1/volumes?q=#{keyword}&maxResults=5&partial=true")
      json = JSON.parse(response.body)
      parse_books(json["items"])
    end

    def parse_books(books)
      books.map do |book|
        volume_info = book["volumeInfo"]

        hash = {}
        hash["author"] = volume_info["authors"].join("")
        hash["title"] = volume_info["title"]
        hash["publisher"] = volume_info["publisher"]

        hash
      end
    end
  end
end
