# encoding: utf-8
require "rubygems"
require "nokogiri"

namespace :parse do 

	task :parse_list_data => :environment do

		raw_list = RawList.first
		page_no = Nokogiri::HTML(raw_list.html)

		item_nums = page_no.css(".shList").size() - 1
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

	task :parse_all_raw_list => :environment do
		all_raw_list = RawList.all
		all_raw_list.each do |raw_list|
			ParseListWorker.perform_async(raw_list.id)
		end
	end

end
