#encoding = utf-8


module GetClassTxt
  def get_whole_page
    puts "get faculty score"
    request = Net::HTTP::Post.new('/reportFiles/zhjwcx/syxqcjxx/zhjwcx_syxqcjxx_jtcjcx.jsp')
    request['Cookie'] = @session
    request.set_form_data("xsh"=>"05", "zxjxjhh"=>"2014-2015-2-1", "bjh"=>"")
    begin
      response = @http.request(request)
    rescue Exception => e
      log_out
      exit
    end
    body = response.body.force_encoding('gbk').encode('utf-8')
  end


  def download_text(html)
    puts "download_text"
    html.match /saveAsText.*\s?\{\s+.*src.*"(.*)";$/
    begin
      request = Net::HTTP::Get.new(URI($1.to_s))
      request['Cookie'] = @session
      request['User-Agent'] = "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/43.0.2357.81 Safari/537.36"
      @http.request(request) do |response|
        return unless response.is_a?(Net::HTTPSuccess)
        File.open("html_file.tmp", "w") do |file|
          response.read_body do |segment|
            file.write(segment)
          end
        end
      end
    rescue Exception => e
      log_out
      exit
    end
    "SUCCESS"
  end

  def log_out
    request = Net::HTTP::Post.new('/logout.do')
    request['Cookie'] = @session
    request.set_form_data("loginType"=>"platformLogin")
    response = @http.request(request)
    puts "logout code: #{response.code}"
  end
end
