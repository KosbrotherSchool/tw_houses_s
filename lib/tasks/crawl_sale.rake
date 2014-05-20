#encoding: utf-8
require "typhoeus"
require "nokogiri"
require "net/http"
require "uri"
require 'capybara'
require 'capybara/dsl'
require 'tesseract'
require "open-uri"



namespace :crawl_sale do

	task :crawl_all_raw_list => :environment do

		counties = County.all
		counties.each do |county|

			region_id = county.county_web_id
			url = "http://sale.591.com.tw/index.php?module=search&action=rslist&is_new_list=1&type=2&searchtype=1&region=#{region_id}&orderType=desc&listview=img"
			uri = URI.parse(url)

			response = Net::HTTP::get_response(uri)
			res = JSON(response.body)

			county.county_house_num = res["count"].gsub(",","").to_i

			puts county.name + " county num = " + county.county_house_num.to_s
			puts "page num = 1"

			rawListPage = RawList.new
			rawListPage.html = res["main"]
			rawListPage.page_num = 1
			rawListPage.county_id = county.id
			rawListPage.is_parsed = false
			rawListPage.save

			county.current_house_page_num = 1
			county.save

			int_pages = county.county_house_num / 20
			if (county.county_house_num%20 == 0)
				int_pages = int_pages -1
			end

			if (int_pages >= 1)
				
				1.upto int_pages do | page_num |
					puts  "page num = " + (page_num+1).to_s
					params = "county_id="+county.id.to_s+","+"page_num="+page_num.to_s
					RawListWorker.perform_async(params)
				end
			end
		end

	end

	task :crawl_all_house_detail => :environment do
		houses = House.where("is_keep_show = true")
		houses.each do |house|
			HouseDetailWorker.perform_async(house.id)
		end
	end

	task :crawl_no_detail_houses => :environment do
		houses = House.where("price is null")
		houses.each do |house|
			HouseDetailWorker.perform_async(house.id)
		end
	end


end