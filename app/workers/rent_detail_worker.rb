class RentDetailWorker
  include Sidekiq::Worker
  sidekiq_options queue: "house"

  def perform(house_id)
    house = RentHouse.find(house_id)
	house_crawler = HouseDetailCrawler.new
	house_crawler.crawl_rent_detail house_id
  end
end