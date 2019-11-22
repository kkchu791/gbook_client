require "httparty"

class GbookApi
  class KeywordMissingError < ArgumentError; end

  class << self
    def get(keyword)
      validate_keyword(keyword)
      response = HTTParty.get("https://www.googleapis.com/books/v1/volumes?q=#{keyword}&maxResults=5&partial=true")
      json = JSON.parse(response.body)

      if json["totalItems"] > 0
        parse_books(json["items"])
      else
        []
      end
    end


    def parse_books(books)
      books.map do |book|
        volume_info = book["volumeInfo"]

        hash = {}
        hash["author"] = (volume_info["authors"] || ["n/a"]).join("")
        hash["title"] = volume_info["title"]
        hash["publisher"] = volume_info["publisher"]

        hash
      end.sort_by { |h| h["author"] }
    end

    private

    def validate_keyword(keyword)
      if keyword.strip.empty?
        raise KeywordMissingError.new("You need to provide a full keyword.")
      end
    end
  end
end
