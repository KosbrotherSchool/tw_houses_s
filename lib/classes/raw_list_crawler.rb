#encoding: utf-8
class RawListCrawler

	def crawl_list(county_id)

		county = County.find(county_id)
		puts "count = " + county.name

		region_id = county.county_web_id

		if county.current_page_num == nil
			
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
			
			county.county_num = res["count"].gsub(",","").to_i
			
			puts "county num = " + county.county_num.to_s
			puts "page num = 1"

			rawListPage = RawList.new
			rawListPage.html = res["main"]
			rawListPage.page_num = 1
			rawListPage.county_id = county.id
			rawListPage.is_parsed = false
			begin
				rawListPage.save
				county.current_page_num = 1
				county.save
			rescue Exception => e
				
			end

		end
					

		int_pages = county.county_num / 20
		if (county.county_num%20 == 0)
			int_pages = int_pages -1
		end

		if (int_pages >= 1)

			1.upto int_pages do | page_num |

				if county.current_page_num == page_num
					
					puts "page num = " + (page_num + 1).to_s

					firstRow = page_num * 20
					totalRows = county.county_num
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
					rawListPage.page_num = 1 + page_num
					rawListPage.county_id = county.id
					rawListPage.is_parsed = false
					begin
						rawListPage.save
						county.current_page_num = page_num + 1
						county.save
					rescue Exception => e
						
					end		

				end
					
			end
		end
	end


	def crawl_rent_list_new(params)
		
		county_id = params[params.index("county_id=")+10..params.index(",")-1].to_i
		page_num = params[params.index("page_num=")+9..params.length].to_i

		county = County.find(county_id)

		region_id = county.county_web_id
		firstRow = page_num * 20
		totalRows = county.county_rent_num
		url = "http://rent.591.com.tw/index.php?module=search&action=rslist&is_new_list=1&type=1&searchtype=1&region=#{region_id}&orderType=desc&listview=img&firstRow=#{firstRow}&totalRows=#{totalRows}"
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

		rawListPage = RawRentList.new
		rawListPage.html = res["main"]
		rawListPage.page_num = 1 + page_num
		rawListPage.county_id = county.id
		rawListPage.is_parsed = false
		begin
			rawListPage.save
			county.current_rent_page_num = page_num + 1
			county.save
		rescue Exception => e
			
		end	
	end

	# def crawl_rent_list(county_id)
		
	# 	county = County.find(county_id)
	# 	puts "count = " + county.name

	# 	region_id = county.county_web_id

	# 	if county.current_rent_page_num == nil
			
	# 		url = "http://rent.591.com.tw/index.php?module=search&action=rslist&is_new_list=1&type=1&searchtype=1&region=#{region_id}&orderType=desc&listview=img&shType=list"
	# 		uri = URI.parse(url)			
			
	# 		code = ""
	# 		while code != "200"
	# 			proxy = Proxy.find(:first, :order => "RAND()")
	# 			proxy_addr = proxy.proxy_addr
	# 			proxy_port = proxy.proxy_port
	# 			# puts "addr = " + proxy_addr + " port = " + proxy_port.to_s
	# 			begin
	# 				response = Net::HTTP::Proxy(proxy_addr, proxy_port).get_response(uri)
	# 				code = response.code
	# 			rescue Exception => e
					
	# 			end	
	# 			if code != "200"
	# 				proxy.delete
	# 			end		
	# 		end
			
	# 		res = JSON(response.body)
			
	# 		county.county_rent_num = res["count"].gsub(",","").to_i
			
	# 		puts "county num = " + county.county_rent_num.to_s
	# 		puts "page num = 1"

	# 		rawListPage = RawRentList.new
	# 		rawListPage.html = res["main"]
	# 		rawListPage.page_num = 1
	# 		rawListPage.county_id = county.id
	# 		rawListPage.is_parsed = false
	# 		begin
	# 			rawListPage.save
	# 			county.current_rent_page_num = 1
	# 			county.save
	# 		rescue Exception => e
				
	# 		end
	# 	end

	# 	int_pages = county.county_rent_num / 20
	# 	if (county.county_rent_num%20 == 0)
	# 		int_pages = int_pages -1
	# 	end

	# 	if (int_pages >= 1)

	# 		1.upto int_pages do | page_num |

	# 			if county.current_rent_page_num == page_num
					
	# 				puts "page num = " + (page_num + 1).to_s

	# 				firstRow = page_num * 20
	# 				totalRows = county.county_rent_num
	# 				url = "http://rent.591.com.tw/index.php?module=search&action=rslist&is_new_list=1&type=1&searchtype=1&region=#{region_id}&orderType=desc&listview=img&firstRow=#{firstRow}&totalRows=#{totalRows}"

	# 				uri = URI.parse(url)
					
	# 				code = ""
	# 				while code != "200"
	# 					proxy = Proxy.find(:first, :order => "RAND()")
	# 					proxy_addr = proxy.proxy_addr
	# 					proxy_port = proxy.proxy_port
	# 					puts "addr = " + proxy_addr + " port = " + proxy_port.to_s
	# 					begin
	# 						response = Net::HTTP::Proxy(proxy_addr, proxy_port).get_response(uri)
	# 						code = response.code
	# 					rescue Exception => e
							
	# 					end	
	# 					if code != "200"
	# 						proxy.delete
	# 					end		
	# 				end

	# 				res = JSON(response.body)

	# 				rawListPage = RawRentList.new
	# 				rawListPage.html = res["main"]
	# 				rawListPage.page_num = 1 + page_num
	# 				rawListPage.county_id = county.id
	# 				rawListPage.is_parsed = false
	# 				begin
	# 					rawListPage.save
	# 					county.current_rent_page_num = page_num + 1
	# 					county.save
	# 				rescue Exception => e
						
	# 				end		
	# 			end					
	# 		end
	# 	end

	# end

	

end