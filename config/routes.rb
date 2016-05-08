Rails.application.routes.draw do

  #routes for the business devise model, will be seperate from other users
  devise_for :businesses, :controllers => {registrations: 'businesses/registrations'}
  devise_scope :business do
    authenticated :business do
      root :to => 'relationships#index', as: :authenticated_business_root
    end
    #unauthenticated :business do
    #  root :to => 'businesses/sessions#new', as: :unauthenticated_business_root
    #end
  end

  #routes created so that root is the sign in page if not signed in, and the home page if user is signed in
  devise_for :users, :controllers => {registrations: 'users/registrations'}
  devise_scope :user do
    authenticated :user do
      root :to => 'receipts#index', as: :authenticated_root
    end
    unauthenticated :user do
      root :to => 'devise/sessions#new', as: :unauthenticated_root
    end
  end

  resources :companies

  resources :receipts do 
    resources :receipt_items
  end

  resources :expense_reports

  resources :received_expense_reports

  resources :relationships

  resources :groups

  resources :users_roles, :only => [:edit, :update]

  resources :users_groups

  resources :roles

  #routecreated for charts page as part of analytics
  get 'spending_trends/charts' => 'spending_trends#charts', as: :charts
  #route created as part of analytics for businesses
  get 'spending_trends/biz_trends' => 'spending_trends#biz_trends', as: :biz_data

  #not sure if this route is needed, not get request should be made for incoming mails
  get '/incoming_mails' => 'incoming_mails#new'
  #route used for the hook used by cloudmailin to enter email parameters leading to receipts being created
  post '/incoming_mails' => 'incoming_mails#create'

  get 'show_users/index'

  get 'all_receipts/index' => 'all_receipts#index', as: :all_receipts

end
