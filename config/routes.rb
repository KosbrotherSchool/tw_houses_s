require 'sidekiq/web'
TwHouses::Application.routes.draw do
  mount Sidekiq::Web, at: '/sidekiq'

end
