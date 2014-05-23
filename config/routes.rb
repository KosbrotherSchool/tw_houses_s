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
		      get 'get_countys'
		      get 'get_county_towns'
		      get 'get_rent_type'
		      get 'get_sale_type'
		    end
		  end
		end
	end

	namespace :api do
		namespace :v2 do
		  resources :house, :only => [:index, :show] do
		    collection do
		      get 'get_houses_by_distance'
		      get 'get_sale_detail'
		    end
		  end
		end
	end


end
