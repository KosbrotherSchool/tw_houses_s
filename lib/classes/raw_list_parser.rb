#encoding: utf-8
class RawListParser

	require "rubygems"
	require "nokogiri"

	def parse_list(raw_list_id)
		
		raw_list = RawList.find(raw_list_id)
		page_no = Nokogiri::HTML(raw_list.html)

		item_nums = page_no.css(".shList").size() - 1
		if item_nums > 0
			0.upto item_nums do | item_num |

			puts "item num = " + item_num.to_s

			house = House.new

			url = "http://sale.591.com.tw/"
			# promote_pic, title, link
			item = page_no.css(".shList")[item_num]

			house.title = item.css(".title").children[0]["title"]
			house.promote_pic_link = item.css(".imgbd").children[0]["src"]
			if house.promote_pic_link.index("nophoto")
				house.promote_pic_link = ""
			end
				house.link = url + item.css(".title").children[0]["href"]
				house.county_id = raw_list.county_id
				house.save
			end

			raw_list.is_parsed = true
			raw_list.save
		end		
	end

	def parse_rent_list(raw_list_id)
		
		raw_list = RawRentList.find(raw_list_id)
		page_no = Nokogiri::HTML(raw_list.html)

		item_nums = page_no.css(".shList").size() - 1
		if item_nums > 0
			0.upto item_nums do | item_num |

				puts "item num = " + item_num.to_s

				

				url = "http://rent.591.com.tw/"
				# promote_pic, title, link
				item = page_no.css(".shList")[item_num]
				house_link = url + item.css(".title").children[0]["href"]
				

				if RentHouse.where("link like ?",house_link).size() >= 1					
					# update
					house = RentHouse.where("link like ?",house_link).first
					house.is_keep_show = true
					house.is_need_update = false
					house.save
				else
					# create
					house = RentHouse.new

					house.title = item.css(".title").children[0]["title"]
					house.promote_pic_link = item.css(".imgbd").children[0]["src"]
					if house.promote_pic_link.index("nophoto")
						house.promote_pic_link = ""
					end

					house.link = url + item.css(".title").children[0]["href"]

					house.county_id = raw_list.county_id
				
					type_s = item.css(".right p")[2].children.to_s
					RentType.all.each do |type|
						if type_s.index(type.name)
							house.rent_type_id = type.id
						end
					end

					house.is_keep_show = true
					house.is_need_update = true

					house.save

				end

				

			end

			raw_list.is_parsed = true
			raw_list.save
		end		
	end

end