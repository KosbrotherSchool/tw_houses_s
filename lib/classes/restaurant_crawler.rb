# encoding: utf-8
class RestaurantCrawler
  include Crawler


  def change_node_br_to_newline node
    content = node.to_html
    content = content.gsub("<br>","\n")
    n = Nokogiri::HTML(content)
    n.text
  end


  def crawl_lat_long res_id
  	res = Restaurant.find(res_id)
  	num = @page_html.css("script").text.index("GLatLng")
    text = @page_html.css("script").text[num..num+30]
  	x = text[text.index("(")+1..text.index(",")-1]
  	y = text[text.index(",")+1..text.index(")")-1]
  	res.x_lat = x
  	res.y_long = y
  	res.save 
  end

  def crawl_res_datas res_id
    res = Restaurant.find(res_id)
    text1 = @page_html.css(".rating i")[0][:style]
    text1 = text1.gsub("width: ","")
    res.grade_food = text1

    text2 = @page_html.css(".rating i")[1][:style]
    text2 = text2.gsub("width: ","")
    res.grade_service = text2

    text3 = @page_html.css(".rating i")[2][:style]
    text3 = text3.gsub("width: ","")
    res.grade_ambiance = text3

    text = @page_html.css("dl.info dd")[0].text.strip
    price = text.gsub(" 元","").to_i
    res.price = price

    res.open_time= @page_html.css("dl.info dd")[4].text.strip
    res.rest_date= @page_html.css("dl.info dd")[5].text.strip
    
    res.rate_num = @page_html.css("span.score-bar meter")[0][:value].to_i
    
    res.introduction = @page_html.css("div.summary").text.strip
    
    nodes = @page_html.css("div#shop-details tr")
    nodes.each do |node|
      if (node.text.index("網站"))
        res.official_link = node.children[2].children[0][:href]
      elsif (node.text.index("地址"))
         res.address = node.children[2].text.strip
         res.area_id = match_address(res.address)
      elsif (node.text.index("電話"))
         res.phone = node.children[2].text.strip
      elsif (node.text.index("推薦"))
         res.recommand_dish = node.children[2].text.strip
      end
    end

    text = @page_html.css("div#shop-location .map img")[0][:src]
    index= text.index("markers=")
    xandy = text[index+8..text.length]
    res.x_lat = xandy[0..xandy.index(",")-1]
    res.y_long = xandy[xandy.index(",")+1..xandy.length]

    res.save
  end

  def crawl_res_note(res_id) 
    res = Restaurant.find(res_id)
    res_link = res.ipeen_link[0..res.ipeen_link.index("-")-1]
    link = res_link + "/comments"
    c = RestaurantCrawler.new
    c.fetch link
    is_crawl = true
    while is_crawl do
      num = c.page_html.css("article .text h2").size()
      i = 0
      while i < num do
        note = Note.new
        note.title = c.page_html.css("article .text h2")[i].text.strip
        note.author = c.page_html.css("article p.name")[i].text.strip
        if (c.page_html.css(".left-column article .cover")[i].css("img").size() != 0)
          note.pic_url = c.page_html.css(".left-column article .cover")[i].css("img")[0][:src]
        end
        note.pub_date = c.page_html.css("article time")[i].text
        note.ipeen_link = "http://www.ipeen.com.tw" + c.page_html.css("article .text h2")[i].children[0][:href]
        note.restaurant_id = res.id
        note.save
        i = i + 1
      end

      if (c.page_html.css(".page-block a").size()!= 0 && c.page_html.css(".page-block a").last.text == "下一頁")
        url = "http://www.ipeen.com.tw/" + c.page_html.css(".page-block a").last[:href]
        c.fetch url
      else
        is_crawl = false
      end
    end
  end

  def match_address(address)
    if (address.index"基隆")
      return 2
    elsif(address.index"台北市")
      return 3
    elsif(address.index"新北市")
      return 4
    elsif(address.index"桃園")
      return 5
    elsif(address.index"新竹市")
      return 6
    elsif(address.index"新竹縣")
      return 7
    elsif(address.index"苗栗")
      return 8
    elsif(address.index"台中")
      return 9
    elsif(address.index"南投")
      return 10
    elsif(address.index"彰化")
      return 11
    elsif(address.index"雲林")
      return 12
    elsif(address.index"嘉義市")
      return 13
    elsif(address.index"嘉義縣")
      return 14
    elsif(address.index"台南")
      return 15
    elsif(address.index"高雄")
      return 16
    elsif(address.index"屏東")
      return 17
    elsif(address.index"宜蘭")
      return 18
    elsif(address.index"花蓮")
      return 19
    elsif(address.index"台東")
      return 20
    elsif(address.index"澎湖")
      return 21
    elsif(address.index"連江")
      return 22
    elsif(address.index"金門")
      return 23
    end                                
  end

end
