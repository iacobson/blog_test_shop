Rails.application.routes.draw do

  root 'products#index'

  resources :products, except: :show
  resources :orders, only: :destroy do
    member do
      #custom PUT actions (outside CRUD) for adding and remove products from the order
      put :add_to
      put :remove_from
    end
  end

  devise_for :users, :controllers => { registrations: 'registrations' }

end
