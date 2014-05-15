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

				url = "http://sale.591.com.tw/"
				# promote_pic, title, link
				item = page_no.css(".shList")[item_num]
				house_link = url + item.css(".title").children[0]["href"]

				if House.where("link like ?",house_link).size() >= 1
					house = House.where("link like ?",house_link).first
					house.is_keep_show = true
					
					update_s = item.css(".right p")[3].children.to_s

					if update_s.index("分鐘") || update_s.index("小時")

						house.promote_pic_link = item.css(".imgbd").children[0]["src"]
						if house.promote_pic_link.index("nophoto")
							house.promote_pic_link = ""
						end
						house.is_need_update = true

					else

						Time.zone = "Taipei"
						time = Time.zone.now
						time_num = time.year * 10000 + time.month * 100 + time.day

						# avoid new item read twice and set is_need_update to false
						if (time_num - house.create_date_num) == 0
							house.is_need_update = true
						else
							house.is_need_update = false
						end

					end				

					house.save

				else
					# create
					house = House.new

					house.title = item.css(".title").children[0]["title"]
					house.promote_pic_link = item.css(".imgbd").children[0]["src"]
					if house.promote_pic_link.index("nophoto")
						house.promote_pic_link = ""
					end

					house.link = url + item.css(".title").children[0]["href"]

					house.county_id = raw_list.county_id
				
					type_s = item.css(".right p")[2].children.to_s
					GroundType.all.each do |type|
						if type_s.index(type.name)
							house.ground_type_id = type.id
						end
					end

					house.is_keep_show = true
					house.is_need_update = true

					Time.zone = "Taipei"
					time = Time.zone.now
					time_num = time.year * 10000 + time.month * 100 + time.day
					house.create_date_num = time_num

					house.save
				end
			end	
		end

		raw_list.is_parsed = true
		raw_list.save

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
					
					update_s = item.css(".right p")[3].children.to_s

					if update_s.index("分鐘") || update_s.index("小時")

						house.promote_pic_link = item.css(".imgbd").children[0]["src"]
						if house.promote_pic_link.index("nophoto")
							house.promote_pic_link = ""
						end
						house.is_need_update = true

					else

						Time.zone = "Taipei"
						time = Time.zone.now
						time_num = time.year * 10000 + time.month * 100 + time.day

						# avoid new item read twice and set is_need_update to false
						if (time_num - house.create_date_num) == 0
							house.is_need_update = true
						else
							house.is_need_update = false
						end

					end				

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

					Time.zone = "Taipei"
					time = Time.zone.now
					time_num = time.year * 10000 + time.month * 100 + time.day
					house.create_date_num = time_num

					house.save

				end

				

			end

			raw_list.is_parsed = true
			raw_list.save
		end		
	end


end