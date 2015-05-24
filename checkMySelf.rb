#encoding = utf-8
require 'net/http'
require 'open-uri'
require 'digest'

require './getClassTxt.rb'

class String
  #等宽字体中英文混合时占用的宽度
  def ulen()
    (self.bytesize + self.length) / 2
  end
end


class Checkmyself
  include GetClassTxt

  attr_accessor :session

  def initialize
    @username = "2012021712"
    @passwd   = "1"
    @host     = "192.168.11.239"
    @port     = 80
    @session  =  nil

    @http = Net::HTTP.new(@host, @port)
  end

  def get_score
    puts "get my score"
    raise "get_session first OR no session" if @session == nil
    request = Net::HTTP::Get.new('/bxqcjcxAction.do')
    request['Cookie'] = @session  
    respones = @http.request(request)
    body = respones.body.force_encoding('gbk').encode('utf-8').gsub(/\s/,"")

    return body
  end
  
  def get_session
    puts "get session"
    request = Net::HTTP::Post.new('/loginAction.do')
    request.set_form_data({ 'zjh' => @username, 'mm' => @passwd })

    respones = @http.request(request)
    return nil  if !respones.code == '200'
    @session = respones["set-cookie"]
  end

  def different?(html)
    puts "diff?"
    last = File.exist?("last_digest") ? File.read("last_digest") : nil
    now = Digest::SHA2.hexdigest(html)
    if last == now
      return true
    else
      File.open("last_digest", "w") { |file| file.print now }
      return false
    end
  end

  def parse_html(html)
    puts "parse my score"
    html =~ /thead(.*)<\/TABLE/
    arr = $1.scan(/>(.{0,15})<\/td/).map(&:first)
    max_ulen = arr.map(&:ulen).max
    arr.each_slice(7) do |row|
      printf("%-9s %-3s %s %s %2s %5s %3s\n",row[0],row[1],row[2]," "*(max_ulen - row[2].ulen),row[3],row[4],row[5],row[6])
    end
  end

end


me = Checkmyself.new

#me.get_session
#html = me.get_score
#if me.different?(html)
#  syncClass
#end
#me.parse_html(html)

#me.get_whole_page



