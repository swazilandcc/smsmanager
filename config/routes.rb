require 'sidekiq/web'

Smsmanager::Application.routes.draw do

  resources :quizzes


  resources :regions


  resources :competitions

  authenticate :user do

    mount Sidekiq::Web, at: "/sidekiq"

  end


  resources :sms_logs


  post '/send_bulk_sms' => "send_bulk_messages#send_bulk_out"

  match '/dashboard/import_contact/:cell_number' => 'dashboard#import_contact'
  match '/dashboard/bulksms_report' => 'dashboard#bulksms_report'
  match '/dashboard/incomingsms_report' => 'dashboard#incomingsms_report'

  match '/dashboard/downloadBulkSMSReport' => 'dashboard#downloadBulkSMSReport'
  match '/dashboard/downloadIncomingSMSReport' => 'dashboard#downloadIncomingSMSReport'

  post '/dashboard/getBulkSMSReport' => 'dashboard#getBulkSMSReport'
  post '/dashboard/getIncomingMessageReport' => 'dashboard#getIncomingMessageReport'

  post '/dashboard/fhLoad' => 'dashboard#fhLoad'

  match "/bulk_message_templates/getMessage" => "bulk_message_templates#getMessage"
  match "/send_bulk_messages/getContacts" => "send_bulk_messages#getContacts"

  resources :send_bulk_messages


  resources :bulk_message_templates


  resources :groups

  match 'contacts/genExcel' => 'contacts#genExcel'


  resources :contacts

  match 'incoming_messages/genExcel' => 'incoming_messages#genExcel'
  match 'incoming_messages/receive' => 'incoming_messages#receive'
  resources :incoming_messages


  devise_for :users, :path_prefix => "system"
  resources :users

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  root :to => 'dashboard#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
