AdpStore::Application.routes.draw do

  resources :news

  # This line mounts Spree's routes at the root of your application.
  # This means, any requests to URLs such as /products, will go to Spree::ProductsController.
  # If you would like to change where this engine is mounted, simply change the :at option to something different.
  #

  # namespace :gateway do
  #   get '/onpay/:gateway_id/:order_id' => 'onpay#show',    :as => :onpay
  #   get '/onpay/api' => 'onpay#api', :as => :onpay_api
  # end

  # We ask that you don't use the :as option here, as Spree relies on it being the default of "spree"

  get '/t_all/*id' => 'spree/taxons#show_all'

  mount Spree::Core::Engine, :at => '/'

  get '/onpay/:gateway_id/:order_id' => 'spree/gateway/onpay#show',    :as => :true_onpay

  get '/admin/news' => 'spree/admin/pages#news_index'
  get '/series/:id' => 'spree/taxons#series'
  get '/admin/add_news' => 'spree/admin/pages#add_news'
  get '/admin/edit_news/:news_item_id' => 'spree/admin/pages#edit_news'
  get '/collection/:news_item_id' => 'spree/static_content#show_news_item'
  patch '/news' => 'news#update'

  post '/sync' => 'spree/static_content#sync_upload'
  put '/sync' => 'spree/static_content#sync_upload'
  #
  get '/sync' => 'spree/static_content#sync_upload'



  # get '/admin/edit_news/:id' => 'spree/admin/pages#edit_news'

          # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
