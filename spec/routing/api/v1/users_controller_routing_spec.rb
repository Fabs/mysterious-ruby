require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :routing do
  describe 'routing' do
    it 'routes to #signup' do
      path = 'api/v1/users#sign_up'
      expect(post: 'v1/users/sign_up', format: 'json').to route_to(path)
    end
  end
end
