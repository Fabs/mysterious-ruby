module Api
  module V1
    class SessionsController < Api::ApiController
      before_filter :auth_service
      respond_to :json

      api :POST, '/v1/users/sign_in', 'Signs in an User creating its Session.
                                       The session will contain the user token
                                       that will be needed on any authenticated
                                       request'
      api_version '1'
      param :user, Hash, 'The user sign in information', required: true do
        param :username, String, 'Must be unique', required: true
        param :password, String, 'Must be the valid user password',
              required: true
      end
      def sign_in
        @session = @auth.authenticate(sign_in_params)
        if @session && @session.valid?
          respond_with(@session, status: :created)
        else
          render json: @auth.errors, status: :not_found
        end
      end

      api :POST, '/v1/users/sign_in', 'Signs off the User\'s Session.'
      api_version '1'
      param :session, Hash, 'The Session to be signed off', required: true do
        param :token, String, 'Must be the valid user token from sign_in',
              required: true
        param :user_id, Numeric, 'Must be the id of the user
                                 that holds the token', required: true
      end
      def sign_off
      end

      private

      def auth_service
        @auth = AuthenticationService.new(User, Session, SecureRandom)
      end

      def sign_in_params
        params.require(:user).permit(:username, :password)
      end
    end
  end
end