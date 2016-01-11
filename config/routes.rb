Rails.application.routes.draw do

  #routes for the business devise model, will be seperate from other users
  #when I return, build scope like users below
  devise_for :businesses, :controllers => {registrations: 'businesses/registrations'}
  #devise_scope :business do
  #  authenticated :business do
  #    root :to => 'relationships#index', as: :authenticated_business_root
  #  end
  #  unauthenticated :business do
  #    root :to => 'devise/sessions#new', as: :unauthenticated_business_root
  #  end
  #end

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

  resources :receipts

  resources :expense_reports

  resources :relationships

  get 'incoming_mails/create'

  get 'show_users/index'

  get 'all_receipts/index'

end
