module Api
  class ApiController < ActionController::API
    include Concerns::AuthenticationConcern
    include Concerns::AuthorizationConcern

    def signed_in?
      return true if current_user.present?

      render json: { error: 'Forbidden Access' }, status: :forbidden
      false
    end

    def assert_ownership(resource)
      return true if current_role == :admin
      return true if owner?(current_user, resource)

      render json: { error: 'Forbidden Access' }, status: :forbidden
      false
    end
  end
end
