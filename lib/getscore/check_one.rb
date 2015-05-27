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
    hosts = ["60.219.165.24", "192.168.11.239"]
    threads = []
    hosts.each do |host|
      threads << Thread.new do
        uri = URI("http://#{host}/loginAction.do")
        response = Net::HTTP.post_form(uri, 'zjh' => @username, 'mm' => @passwd)
        return if "200" != response.code
        threads.each { |thread| Thread.kill(thread) if thread != Thread.current }
        @host = host
        @session = response["set-cookie"]
        puts "*#{@session}*"
        puts "#{host}"
      end
    end
    threads.each(&:join)
  end

  def get_session
    puts "force get session"
    request = Net::HTTP::Post.new('/loginAction.do')
    request.set_form_data({ 'zjh' => @username, 'mm' => @passwd })
    response = @http.request(request)

    raise "can't get session"  if !response.code == '200'
    @session = response["set-cookie"]
  end

  def get_score
    puts "get my score"
    raise "get_session first OR no session" if @session == nil
    request = Net::HTTP::Get.new('/bxqcjcxAction.do')
    request['Cookie'] = @session
    response = @http.request(request)
    @body = response.body.force_encoding('gbk').encode('utf-8').gsub(/\s/,"")

    self
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
