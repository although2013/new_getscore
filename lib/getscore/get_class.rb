#encoding = utf-8


module GetClassTxt
  def get_whole_page
    puts "get faculty score"
    request = Net::HTTP::Post.new('/reportFiles/zhjwcx/syxqcjxx/zhjwcx_syxqcjxx_jtcjcx.jsp')
    request['Cookie'] = @session
    request.set_form_data("xsh"=>"05", "zxjxjhh"=>"2014-2015-2-1", "bjh"=>"")
    respones = @http.request(request)
    body = respones.body.force_encoding('gbk').encode('utf-8')
  end


  def download_text(html)
    puts "download_text"
    html.match /saveAsText.*\s?\{\s+.*src.*"(.*)";$/

    request = Net::HTTP::Get.new(URI($1.to_s))
    respones = @http.request(request)
    body = respones.body
    File.open("html_file.tmp", "w") { |file| file.write(body)  }
  end
end