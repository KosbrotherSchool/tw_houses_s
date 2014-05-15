class RawListWorker
  include Sidekiq::Worker
  sidekiq_options queue: "house"

  def perform(params)
	raw_list_crawler = RawListCrawler.new
	raw_list_crawler.crawl_list params
  end
end