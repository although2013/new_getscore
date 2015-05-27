require 'minitest/autorun'
require 'getscore'

class GetscoreTest < Minitest::Test

  def test_all
    me = CheckOne.new("2012021712", "1")
    me.get_score.parse_html

    page = me.get_whole_page
    me.download_text(page)
  end

end