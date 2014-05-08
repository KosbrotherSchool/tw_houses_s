#encoding: utf-8
require "typhoeus"
require "nokogiri"
require "net/http"
require "uri"
require 'capybara'
require 'capybara/dsl'
require 'tesseract'
require "open-uri"



namespace :crawl do

	#  url 
	#  module = search
	#  action = rslist
	#  is_new_list = 1
	#  type = 2
	#  searchtype = 1
	#  region 
	#  orderType = desc (by time)
	#  listview=img
	#  firstRow
	#  totalRows


	task :crawl_town_lat_lng => :environment do
		towns = Town.where("x_lng is Null")
		towns.each do |town|

			puts town.name

			search_s = County.find(town.county_id).name + town.name

			url = "http://maps.googleapis.com/maps/api/geocode/json?address=#{search_s}&sensor=false"
			url = URI.encode(url)
			uri = URI.parse(url)

			response = Net::HTTP.get_response(uri)
			# puts response.body

			res = JSON(response.body)
			town.y_lat = res["results"][0]["geometry"]["location"]["lat"]
			town.x_lng = res["results"][0]["geometry"]["location"]["lng"]
			town.save	

			sleep(2)

		end
	end

	task :load_proxy_list => :environment do

		File.open('_reliable_list.txt').each_line{ |s|
		  puts s
		  proxy_addr = s[0..s.index(":")-1]
		  proxy_port = s[s.index(":")+1..s.length].to_i
		  proxy = Proxy.new
		  proxy.proxy_addr = proxy_addr
		  proxy.proxy_port = proxy_port
		  proxy.save
		}

	end

	task :test_proxy => :environment do
		url = "http://ruby-doc.org/"
		uri = URI.parse(url)
		proxy_addr = "116.236.216.116"
		proxy_port = 8080
		response = Net::HTTP::Proxy(proxy_addr, proxy_port).get_response(uri)
		# response.body
		if response.code == "200"
			puts "OK"
		else
			puts "NO"
		end
	end

	task :crawl_all_raw_list => :environment do
		counties = County.all
		counties.each do |county|
			RawListWorker.perform_async(county.id)
		end
	end

	task :crawl_list_data => :environment do


		County.all.each do | county |

			puts "count = " + county.name

			region_id = county.county_web_id

			# url = "http://sale.591.com.tw/index.php?module=search&action=rslist&is_new_list=1&type=2&searchtype=1&region=#{region_id}&orderType=desc&listview=img"
			url = "http://sale.591.com.tw/index.php?module=search&action=rslist&is_new_list=1&type=2&searchtype=1&region=#{region_id}&orderType=desc&kind=9"
			uri = URI.parse(url)			
			
			code = ""
			while code != "200"
				proxy = Proxy.order("RAND()").first
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
			
			res = JSON(response.body)
			
			county.county_nums = res["count"].gsub(",","").to_i
			county.save

			puts "county nums = " + county.county_nums.to_s
			puts "page num = 1"

			rawListPage = RawList.new
			rawListPage.html = res["main"]
			rawListPage.page_num = 1
			rawListPage.county_id = county.id
			rawListPage.is_parsed = false
			rawListPage.save
						

			int_pages = county.county_nums / 20
			if (county.county_nums%20 == 0)
				int_pages = int_pages -1
			end

			if (int_pages >= 1)

				1.upto int_pages do | page_num |

					puts "page num = " + (page_num + 1).to_s

					firstRow = page_num * 20
					totalRows = county.county_nums
					url = "http://sale.591.com.tw/index.php?module=search&action=rslist&is_new_list=1&type=2&searchtype=1&region=#{region_id}&orderType=desc&listview=img&firstRow=#{firstRow}&totalRows=#{totalRows}"

					uri = URI.parse(url)
					
					code = ""
					while code != "200"
						proxy = Proxy.order("RAND()").first
						proxy_addr = proxy.proxy_addr
						proxy_port = proxy.proxy_port
						puts "addr = " + proxy_addr + " port = " + proxy_port.to_s
						begin
							response = Net::HTTP::Proxy(proxy_addr, proxy_port).get_response(uri)
							code = response.code
						rescue Exception => e
							
						end	
						if code != "200"
							proxy.delete
						end		
					end

					res = JSON(response.body)

					rawListPage = RawList.new
					rawListPage.html = res["main"]
					rawListPage.page_num = 1
					rawListPage.county_id = county.id
					rawListPage.is_parsed = false
					rawListPage.save

					
				end
			end
		end		
	end

	task :crawl_list_data_test => :environment do

		# ChunHua 
		region_id = 10 

		# url = "http://sale.591.com.tw/index.php?module=search&action=rslist&is_new_list=1&type=2&searchtype=1&region=#{region_id}&orderType=desc&listview=img"
		url = "http://sale.591.com.tw/index.php?module=search&action=rslist&is_new_list=1&type=2&searchtype=1&region=#{region_id}&orderType=desc&kind=9"

		uri = URI.parse(url)
		response = Net::HTTP.get_response(uri)
		res = JSON(response.body)

		county_nums = res["count"].gsub(",","").to_i

		puts "county nums = " + county_nums.to_s
		puts "page num = 1"

		rawListPage = RawList.new
		rawListPage.html = res["main"]
		rawListPage.page_num = 1
		rawListPage.county_id = region_id
		rawListPage.is_parsed = false
		rawListPage.save

		int_pages = county_nums / 20
		if (county_nums%20 == 0)
			int_pages = int_pages -1
		end

		if (int_pages >= 1)

			1.upto int_pages do | page_num |

				puts "page num = " + (page_num + 1).to_s

				firstRow = page_num * 20
				totalRows = county_nums
				url = "http://sale.591.com.tw/index.php?module=search&action=rslist&is_new_list=1&type=2&searchtype=1&region=#{region_id}&orderType=desc&listview=img&firstRow=#{firstRow}&totalRows=#{totalRows}"

				uri = URI.parse(url)
				response = Net::HTTP.get_response(uri)
				res = JSON(response.body)

				rawListPage = RawList.new
				rawListPage.html = res["main"]
				rawListPage.page_num = 1
				rawListPage.county_id = region_id
				rawListPage.is_parsed = false
				rawListPage.save
			end
		end

	end


	task :crawl_data_by_capybara => :environment do

		include Capybara::DSL
		Capybara.current_driver = :selenium
		Capybara.app_host = 'http://sale.591.com.tw/'
		page.visit ''
		find("#regionSh").click
		find("#areabox").find('.list').all('a')[0].click
		find('#areabox-many-n').click
		sleep(5)
		
		i = 1
		# crawl first page

		#  next page		
		while ( all('.last.pageNext').size() == 0 )
			find('.pageNext').click
			i = i + 1
			puts i.to_s
			sleep(5)
		end

		# seems cant use capybara, because 
	end

	task :crawl_all_house_detail => :environment do
		houses = House.all
		houses.each do |house|
			HouseDetailWorker.perform_async(house.id)
		end
	end


	task :crawl_detail_data => :environment do

		crawler = RestaurantCrawler.new
		house = House.find(2)

		crawler.fetch house.link
		
		detail = crawler.page_html.css("#detailInfo")
		house.price = detail.css("li")[0].css("em").children.to_s.gsub(",","").to_i
		house.address = detail.css("li .addr").children.to_s
		Town.where("county_id = #{house.county_id}").each do |town|
			puts town.name
			if house.address.index(town.name)
				house.town_id = town.id
			end
		end

		house.square_price = detail.css("li")[1].css("em").children.to_s.to_d
		
		ss = detail.css("li")[2].children[1].children[0].to_s
		house.rooms = ss[0..ss.index("房")-1].to_i
		if ss.index("廳")
			house.living_rooms = ss[ss.index("房")+1..ss.index("廳")-1].to_i
		end
		if ss.index("廳") && ss.index("衛")
			house.rest_rooms = ss[ss.index("廳")+1..ss.index("衛")-1].to_i
		end
		if ss.index("陽台") && ss.index("衛")
			house.balconies = ss[ss.index("衛")+1..ss.index("陽台")-1].to_i
		end
		
		house.total_area = detail.css("li")[3].css(".multiLine").children[0].to_s.to_d

		ll = detail.css("li")[4].children[1].children.to_s
		layer_s = ll[0..ll.index("/")-1]
		if layer_s.index("F")
			house.layer = layer_s[0..layer_s.index("F")-1].to_i
		elsif layer_s.index("整棟")
			house.layer = 0
		end
		house.total_lyaers= ll[ll.index("/")+1..ll.length].to_i

		age_s = detail.css("li")[5].children[1].children.to_s
		if age_s.index("年")
			house.building_age = age_s.to_i
		else
			house.building_age = 0
		end

		type_num = 6
		if detail.css("li")[6].to_s.index("型態/類型")
			type_num = 6
		else
			type_num = 7
		end

		type_s = detail.css("li")[type_num].children[1].children.to_s
		building_type_s = type_s[0..type_s.index("/")-1]
		if building_type_s.index("公寓")
			house.building_type_id = 1
		elsif building_type_s.index("大樓")
			house.building_type_id = 2
		elsif building_type_s.index("透天")
			house.building_type_id = 3
		elsif building_type_s.index("別墅")
			house.building_type_id = 3
		else
			house.building_type_id = 4
		end

		ground_type_s = type_s[type_s.index("/")+1..type_s.length]
		if ground_type_s.index("住宅")
			house.ground_type_id = 1
		else
			house.ground_type_id = 2
		end

		house.parking_type = detail.css("li")[type_num+1].children[1].children.to_s


		other_info = crawler.page_html.css("#sale-other-info")
		0.upto other_info.children.size()-1 do |item_num|

			if other_info.children[item_num].to_s.index("管理費")
				gp = other_info.children[item_num].children.to_s
				if gp.index("元")
					house.guard_price = gp[gp.index("：")+1..gp.index("元")-1].to_i
				end
			elsif other_info.children[item_num].to_s.index("朝向")
				os = other_info.children[item_num].children.to_s
				house.orientation = os[os.index("：")+1..os.length]
			elsif other_info.children[item_num].to_s.index("租約")
				rs = other_info.children[item_num].children.to_s
				if rs.index("是")
					house.is_renting = true
				elsif rs.index("否")
					house.is_renting = false
				end
			elsif other_info.children[item_num].to_s.index("坪數說明")
				gp = other_info.children[item_num].children.to_s
				# house.ground_explanation = other_info.children[item_num].children.to_s
				house.ground_explanation = gp[gp.index("：")+1..gp.length]
			elsif other_info.children[item_num].to_s.index("生活")
				lp = other_info.children[item_num].children.to_s
				house.living_explanation = lp[lp.index("：")+1..lp.length]
			end

		end

		house.feature_html = crawler.page_html.css(".feature .inner").to_html

		house.verder_name = crawler.page_html.css(".contact .linkman")[0].children[0].to_s
		house.phone_link = crawler.page_html.css(".contact .number")[0].children.children[0]["src"]

		latlan_s = crawler.page_html.css("#mapRound").children[1].children[0].to_s
		latlan_s = latlan_s[latlan_s.index("q=")+2..latlan_s.index("&z=")-1]
		house.x_long =  latlan_s[0..latlan_s.index(",")-1].to_d
		house.y_lat = latlan_s[latlan_s.index(",")+1..latlan_s.length].to_d
		house.save

		# crawl pics
		pic_nums = crawler.page_html.css(".thumbnails li").size()
		0.upto pic_nums -1 do |pic_num|
			pic_link = crawler.page_html.css(".thumbnails li")[pic_num].children[0].children[0]["src"]
			pic_link = pic_link.gsub("94x68","374x269")
			picture = Picture.new
			picture.picture_link = pic_link
			picture.house_id = house.id
			picture.save
		end


	end

	

end


# http://sale.591.com.tw/index.php?module=search&action=rslist&is_new_list=1&type=2&searchtype=1&region=8&orderType=desc&listview=img&section=104
# http://sale.591.com.tw/index.php?module=search&action=rslist&is_new_list=1&type=2&searchtype=1&region=8&orderType=desc&listview=img
# http://sale.591.com.tw/index.php?module=search&action=rslist&is_new_list=1&type=2&searchtype=1&region=8&orderType=desc&listview=img&section=103,104,105
# http://sale.591.com.tw/index.php?module=search&action=rslist&is_new_list=1&type=2&searchtype=1&region=8&orderType=desc&listview=img&section=103,104,105&firstRow=20&totalRows=9743
# http://sale.591.com.tw/index.php?module=search&action=rslist&is_new_list=1&type=2&searchtype=1&region=8&orderType=desc&listview=img&section=103,104,105&firstRow=0&totalRows=9744








