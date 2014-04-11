class RawRentListNewWorker
  include Sidekiq::Worker
  sidekiq_options queue: "house"

  def perform(params)
	raw_list_crawler = RawListCrawler.new
	raw_list_crawler.crawl_rent_list_new params
  end
end