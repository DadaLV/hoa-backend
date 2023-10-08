Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      mount_devise_token_auth_for 'User', at: 'auth', skip: [:invitations],
      controllers: {
        passwords: 'api/v1/passwords' }
      devise_for :users, path: "auth", only: [:invitations],
        controllers: { invitations: 'api/v1/invitations' }
    end 
  end
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
