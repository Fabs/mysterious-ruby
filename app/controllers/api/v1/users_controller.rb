module Api
  module V1
    class UsersController < Api::ApiController
      respond_to :json

      api :POST, '/v1/users/sign_up', 'Signs up an User by creating it.'
      api_version '1'
      param :user, Hash, 'The user sign up information', required: true do
        param :username, String, 'Must be unique', required: true
        param :password, String, 'Must have 8 to 72 characters', required: true
        param :password_confirmation, String,
              'Must match the password field', required: true
        param :admin, :bool, 'True if the user is an admin'
      end
      def sign_up
        @user = User.new(sign_up_parameters)
        if @user.save
          respond_with @user, status: :created
        else
          render json: @user.errors, status: :not_found
        end
      end

      private

      def sign_up_parameters
        params.require(:user).permit(:username,
                                     :password,
                                     :password_confirmation,
                                     :admin)
      end
    end
  end
end
