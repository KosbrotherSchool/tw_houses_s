class RawRentListWorker
  include Sidekiq::Worker
  sidekiq_options queue: "house"

  def perform(county_id)
	raw_list_crawler = RawListCrawler.new
	raw_list_crawler.crawl_rent_list county_id
  end
end