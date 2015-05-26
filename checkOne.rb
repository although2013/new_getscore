#encoding = utf-8
require 'net/http'
require 'open-uri'
require 'digest'


class String
  #等宽字体中英文混合时占用的宽度
  def ulen()
    (self.bytesize + self.length) / 2
  end
end


class CheckOne
  attr_accessor :session

  def initialize(username, passwd)
    @username = username
    @passwd   = passwd
    @port     = 80
    @session  = nil

    check_internet
    @http = Net::HTTP.new(@host, @port)
  end

  def check_internet
    @host = "192.168.11.239"
    resp = Net::HTTP.get_response(@host, '/loginAction.do')
    @host = "60.219.165.24" if resp.code != 200
  end

  def get_score
    puts "get my score"
    raise "get_session first OR no session" if @session == nil
    request = Net::HTTP::Get.new('/bxqcjcxAction.do')
    request['Cookie'] = @session  
    respones = @http.request(request)
    @body = respones.body.force_encoding('gbk').encode('utf-8').gsub(/\s/,"")

    self
  end
  
  def get_session
    puts "get session"
    request = Net::HTTP::Post.new('/loginAction.do')
    request.set_form_data({ 'zjh' => @username, 'mm' => @passwd })
    respones = @http.request(request)

    return nil  if !respones.code == '200'
    @session = respones["set-cookie"]
  end

  def different?
    puts "diff?"
    last = File.exist?("last_digest.tmp") ? File.read("last_digest.tmp") : nil
    now = Digest::SHA2.hexdigest(@body)

    if last == now
      return false
    else
      puts "It's different now!"
      File.open("last_digest.tmp", "w") { |file| file.print now }
      return true
    end
  end

  def parse_html
    puts "parse my score"
    @body =~ /thead(.*)<\/TABLE/
    arr = $1.scan(/>(.{0,15})<\/td/).map(&:first)
    max_ulen = arr.map(&:ulen).max
    puts "---------------------------------------------------"
    arr.each_slice(7) do |row|
      printf("%-9s %-4s %-s %s %-5s %-4s %-4s\n",row[0],row[1],row[2],(" "*(max_ulen - row[2].ulen)),row[4],row[5],row[6])
    end
  end

end



