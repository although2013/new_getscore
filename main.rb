#encoding = utf-8
require './getClassTxt'
require './checkOne'


class CheckOne
  include GetClassTxt
end


me = CheckOne.new("2012021712", "1")

me.get_session

me.get_score.parse_html

if me.different?
  page = me.get_whole_page
  me.download_text(page)
end



