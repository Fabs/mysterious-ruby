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
      end
    end
  end
end
