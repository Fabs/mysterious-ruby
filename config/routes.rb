Rails.application.routes.draw do
  apipie
  namespace :api, path: '', constraints: {format: 'json'} do
    namespace :v1 do
      post 'users/sign_up'
    end
  end
end
