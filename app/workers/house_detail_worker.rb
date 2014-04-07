class HouseDetailWorker
  include Sidekiq::Worker
  sidekiq_options queue: "house"

  def perform(house_id)
    house = House.find(house_id)
	house_crawler = HouseDetailCrawler.new
	house_crawler.crawl_detail house_id
  end
end