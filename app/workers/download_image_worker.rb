class DownloadImageWorker
  include Sidekiq::Worker
  sidekiq_options queue: "house"

  def perform(house_id)
    house = House.find(house_id)
	url =  house.phone_link
	downloaded_file = File.open("phone_pics/image#{house.id}.jpeg",'wb')
		
	request = Typhoeus::Request.new(
		url		
	)

	request.on_body do |chunk|
	  downloaded_file.write(chunk)
	end

	request.run
  end
end