module Api
  class ApiController < ActionController::API
    include AuthenticationConcern
  end
end
