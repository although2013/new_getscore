#encoding = utf-8
require 'getscore/get_class'
require 'getscore/check_one'


class CheckOne
  include GetClassTxt
end

#
#
#me = CheckOne.new("2012021713", "1")
#page = me.get_whole_page
#
#loop do
#  break if "SUCCESS" == me.download_text(page)
#  sleep(3)
#end
#
