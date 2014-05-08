class DownloadImageWorker
  include Sidekiq::Worker
  sidekiq_options queue: "house"

  	def perform(house_id)
	    house = RentHouse.find(house_id)
	    if house.phone_number == nil
	    	# puts house_id.to_s
			url =  house.phone_link
			downloaded_file = File.open("phone_pics/image#{house.id}.jpeg",'wb')
			
			proxy = Proxy.order("RAND()").first
		    proxy_addr = proxy.proxy_addr
		    proxy_port = proxy.proxy_port.to_s

			request = Typhoeus::Request.new(
				url,
				:proxy => proxy_addr+":"+proxy_port,
				:timeout => 50, 
				:forbid_reuse => true
			)

			request.on_body do |chunk|
			  downloaded_file.write(chunk)
			end

			request.run

			if request.response.code != 200
				# puts request.response.code
				puts house_id.to_s + " fail"
				proxy.delete
				#  do again
				DownloadImageWorker.perform_async(house.id)
			else
				puts house_id.to_s + " OK"
				# add to OcrWorker
				# OcrWorker.perform_async(house.id)
			end
		end
  	end
end