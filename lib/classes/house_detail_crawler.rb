#encoding: utf-8
class HouseDetailCrawler
	include Crawler

	require "typhoeus"
	require "nokogiri"
	require "net/http"
	require "uri"
	require 'tesseract'
	require "open-uri"

	def crawl_detail(house_id)

		crawler = HouseDetailCrawler.new
		house = House.find(house_id)

		puts house.title

		crawler.fetch house.link
		
		detail = crawler.page_html.css("#detailInfo")
		house.price = detail.css("li")[0].css("em").children.to_s.gsub(",","").to_i
		house.address = detail.css("li .addr").children.to_s
		Town.where("county_id = #{house.county_id}").each do |town|
			if house.address.index(town.name)
				# puts town.name
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
