Rails.application.routes.draw do

  #routes created so that root is the sign in page if not signed in, and the home page if user is signed in
  #devise_for :users, :controllers => {registrations: 'registrations'}
  devise_for :users
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

end
