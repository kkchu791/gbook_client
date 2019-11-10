require_relative '../lib/list_renderer.rb'
require 'byebug'

describe 'ListRender' do
  describe '#display' do
    context "when given a list" do
      it "prints the list to the screen" do
        list = [
          {"author": "author1", "title": "title1", "publisher": "publisher1"},
          {"author": "author2", "title": "title2", "publisher": "publisher2"},
          {"author": "author3", "title": "title3", "publisher": "publisher3"}
        ]
        ListRenderer.display(list)
        printed_list =
                      %q{1. {:author=>"author1", :title=>"title1", :publisher=>"publisher1"}
                      2. {:author=>"author2", :title=>"title2", :publisher=>"publisher2"}
                      3. {:author=>"author3", :title=>"title3", :publisher=>"publisher3"}}

        expect{ListRenderer.display(list)}.to output{printed_list}.to_stdout
      end
    end
  end
end
