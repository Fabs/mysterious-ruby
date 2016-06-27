Rails.application.routes.draw do
  apipie

  namespace :api, path: '', constraints: {format: 'json'} do
    namespace :v1 do
      namespace :users do
        post 'sign_up'
      end

      namespace :sessions do
        post 'sign_in'
        delete 'sign_off'
        get 'status'
      end

      resources :images, except: [:new, :edit] do
        resources :scores, except: [:new, :edit, :delete]
      end
    end
  end

  root to:'api/v1/sessions#status'
end
