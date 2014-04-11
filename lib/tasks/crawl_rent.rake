#encoding: utf-8
require "typhoeus"
require "nokogiri"
require "net/http"
require "uri"
require 'tesseract'
require "open-uri"

namespace :crawl_rent do

	task :crawl_all_raw_list => :environment do
		counties = County.all
		counties.each do |county|
			RawRentListWorker.perform_async(county.id)
		end
	end

	task :new_carawl_all_raw_list => :environment do

		counties = County.all
		counties.each do |county|

			region_id = county.county_web_id

			url = "http://sale.591.com.tw/index.php?module=search&action=rslist&is_new_list=1&type=2&searchtype=1&region=#{region_id}&orderType=desc&kind=9"
			uri = URI.parse(url)			

			response = Net::HTTP::get_response(uri)
			res = JSON(response.body)
			
			county.county_rent_num = res["count"].gsub(",","").to_i
			
			puts county.name + " county num = " + county.county_rent_num.to_s
			puts "page num = 1"

			rawListPage = RawRentList.new
			rawListPage.html = res["main"]
			rawListPage.page_num = 1
			rawListPage.county_id = county.id
			rawListPage.is_parsed = false
			
			rawListPage.save
			county.current_rent_page_num = 1
			county.save
			
			int_pages = county.county_rent_num / 20
			if (county.county_rent_num%20 == 0)
				int_pages = int_pages -1
			end

			if (int_pages >= 1)
				1.upto int_pages do | page_num |

					puts  "page num = " + (page_num+1).to_s
					params = "county_id="+county.id.to_s+","+"page_num="+page_num.to_s
					RawRentListNewWorker.perform_async(params)
				end
			end
		end
	end

	task :crawl_rent_list_data_test => :environment do

		# ChunHua 
		region_id = 10 

		# url = "http://sale.591.com.tw/index.php?module=search&action=rslist&is_new_list=1&type=2&searchtype=1&region=#{region_id}&orderType=desc&listview=img"
		# url = "http://sale.591.com.tw/index.php?module=search&action=rslist&is_new_list=1&type=2&searchtype=1&region=#{region_id}&orderType=desc&kind=9"
		url = "http://rent.591.com.tw/index.php?module=search&action=rslist&is_new_list=1&type=1&searchtype=1&region=#{region_id}&orderType=desc&listview=img&shType=list"

		uri = URI.parse(url)
		response = Net::HTTP.get_response(uri)
		res = JSON(response.body)

		county_nums = res["count"].gsub(",","").to_i

		puts "county nums = " + county_nums.to_s
		puts "page num = 1"

		rawListPage = RawRentList.new
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

				rawListPage = RawRentList.new
				rawListPage.html = res["main"]
				rawListPage.page_num = 1
				rawListPage.county_id = region_id
				rawListPage.is_parsed = false
				rawListPage.save
			end
		end

	end

	task :crawl_all_rent_house_detail => :environment do
		houses = RentHouse.where("is_keep_show = true")
		houses.each do |house|
			RentDetailWorker.perform_async(house.id)
		end
	end

	task :crawl_detail_data_test => :environment do

		crawler = RestaurantCrawler.new
		house = RentHouse.find(42)

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

		li_num= detail.css("li").size() - 1

		1.upto li_num do |num|

			if detail.css("li")[num].children[0].to_s.index("押金")
				house.deposit = detail.css("li")[num].children[1].children.to_s
			end

			if detail.css("li")[num].children[0].to_s.index("格局")
				ss = detail.css("li")[num].children[1].children[0].to_s
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
			end

			if detail.css("li")[num].children[0].to_s.index("坪數")
				house.rent_area = detail.css("li")[num].css(".multiLine").children[0].to_s.to_d
			end

			if detail.css("li")[num].children[0].to_s.index("樓層")			
				ll = detail.css("li")[num].children[1].children.to_s
				layer_s = ll[0..ll.index("/")-1]
				if layer_s.index("F")
					house.layer = layer_s[0..layer_s.index("F")-1].to_i
				elsif layer_s.index("整棟")
					house.layer = 0
				end
				house.total_lyaers= ll[ll.index("/")+1..ll.length].to_i
			end

			if detail.css("li")[num].children[0].to_s.index("型態")	
				type_s = detail.css("li")[num].children.children[1].to_s
				if type_s.index("公寓")
					house.building_type_id = 1
				elsif type_s.index("大樓")
					house.building_type_id = 2
				elsif type_s.index("透天")
					house.building_type_id = 3
				elsif type_s.index("別墅")
					house.building_type_id = 3
				else
					house.building_type_id = 4
				end
			end

			if detail.css("li")[num].children[0].to_s.index("車位")	
				house.parking_type = detail.css("li")[num].children[1].children.to_s
			end



		end		
			
		other_info_items = crawler.page_html.css(".contenter")[0].css(".inner").children

		0.upto other_info_items.size()-1 do |item_num|

			if other_info_items[item_num].to_s.index("管理費")
				gp = other_info_items[item_num].children.to_s
				if gp.index("元")
					house.guard_price = gp[gp.index("：")+1..gp.index("元")-1].to_i
				end
			elsif other_info_items[item_num].to_s.index("朝向")
				os = other_info_items[item_num].children.to_s
				house.orientation = os[os.index("：")+1..os.length]
			elsif other_info_items[item_num].to_s.index("最短租期")
				ss = other_info_items[item_num].children.to_s
				house.mint_rent_time  = ss[ss.index("：")+1..ss.length]
			elsif other_info_items[item_num].to_s.index("開伙")
				house.is_cooking = true
			elsif other_info_items[item_num].to_s.index("寵物")
				house.is_pet = true
			elsif other_info_items[item_num].to_s.index("身份要求")
				is = other_info_items[item_num].children.to_s
				house.identity = is[is.index("：")+1..is.length]
			elsif other_info_items[item_num].to_s.index("性別要求")
				ss = other_info_items[item_num].children.to_s
				# house.sexual_restriction  = ss[ss.index("：")+1..ss.length]
			elsif other_info_items[item_num].to_s.index("提供家俱")
				items = other_info_items[item_num+1].children
				item_s = ""
				if items.size() > 0
					0.upto items.size()-1 do |num|
						if num != items.size()-1
							item_s = item_s + items[num].children.to_s + ","
						else
							item_s = item_s + items[num].children.to_s
						end
					end
				end
				house.furniture = item_s
			elsif other_info_items[item_num].to_s.index("提供設備")
				items = other_info_items[item_num+1].children
				item_s = ""
				if items.size() > 0
					0.upto items.size()-1 do |num|
						if num != items.size()-1
							item_s = item_s + items[num].children.to_s + ","
						else
							item_s = item_s + items[num].children.to_s
						end
					end
				end
				house.equipment = item_s
			elsif other_info_items[item_num].to_s.index("生活機能")
				lp = other_info_items[item_num].children.to_s
				house.living_explanation = lp[lp.index("：")+1..lp.length]
			elsif other_info_items[item_num].to_s.index("附近交通")
				cs = other_info_items[item_num].children.to_s
				house.communication = cs[cs.index("：")+1..cs.length]
			end

		end

		feature_html = crawler.page_html.css(".feature .inner")
		feature_html.css(".shop_info").remove
		house.feature_html = feature_html.to_html

		house.verder_name = crawler.page_html.css(".contact .linkman")[0].children[0].to_s
		house.phone_link = crawler.page_html.css(".contact .number")[0].children.children[0]["src"]
		
		latlan_s = crawler.page_html.css("#mapRound").children[1].children[0]["src"]
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







