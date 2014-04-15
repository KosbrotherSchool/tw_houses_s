require 'sidekiq/web'
TwHouses::Application.routes.draw do
  mount Sidekiq::Web, at: '/sidekiq'

  namespace :api do
	namespace :v1 do
	  resources :house, :only => [:index, :show] do
	    collection do
	      get 'get_rents_by_ids'
	      get 'get_rent_detail'
	      get 'get_rents_by_distance'
	    end
	  end
	end
end


end
