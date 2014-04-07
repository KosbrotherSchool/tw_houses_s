module Crawler
  
  require 'nokogiri'
  require 'open-uri'
  # require 'iconv'
  require 'net/http'
  
  attr_accessor :page_url, :page_html, :res_address
  
  def fetch_address_site res_address
    @res_address = res_address
    url = "http://map.longwin.com.tw/addr_geo.php?addr=" + @res_address
    @page_url = URI::encode(url)
    @page_html = get_page(@page_url)
  end

  def fetch url
    @page_url = url
    @page_html = get_page(@page_url)   
  end

  def fetch_db_json url
    @page_url = url
    body = ''
    begin
      open(url){ |io|
          body = io.read
      }
    rescue
    end
    @page_html = body
  end

  def post_fetch url, option
    @page_url = url
    url = URI.parse(url)
    resp, data = Net::HTTP.post_form(url, option)
    @page_html = Nokogiri::HTML(resp.body)
  end
  
  def get_page url
    
    # @page_url = url
    # body = ''
    # begin
    #   open(url){ |io|
    #       body = io.read
    #   }
    # rescue
    # end

    @page_url = url
    uri = URI.parse(url)  

    code = ""
    while code != "200"
      proxy = Proxy.find(:first, :order => "RAND()")
      proxy_addr = proxy.proxy_addr
      proxy_port = proxy.proxy_port
      # puts "addr = " + proxy_addr + " port = " + proxy_port.to_s
      begin
        response = Net::HTTP::Proxy(proxy_addr, proxy_port).get_response(uri)
        code = response.code
      rescue Exception => e
        
      end 
      if code != "200"
        proxy.delete
      end   
    end
    body = response.body
    doc = Nokogiri::HTML(body, nil, "UTF-8")
    
  end

  
  def get_item_href dns, src
    if (/^\/\// =~ src)
      src = "http:" + src
    elsif (/^\// =~ src)
      src = dns + src
    elsif (/\.\./ =~ src)
      src = dns + src[2..src.length]
    else
      src 
    end
  end
  
  def parse_dns
    url_scan = @page_url.scan(/.*?\//)
    dns = url_scan[0] + url_scan[1] + url_scan[2]
  end

  
end