require 'rails_helper'

RSpec.describe Api::V1::SessionsController, type: :routing do
  describe 'routing' do
    it 'routes to #sign_in' do
      path = 'v1/sessions/sign_in'
      handler = 'api/v1/sessions#sign_in'
      expect(post: path, format: 'json').to route_to(handler)
    end

    it 'routes to #sign_off' do
      path = 'v1/sessions/sign_off'
      handler = 'api/v1/sessions#sign_off'
      expect(post: path, format: 'json').to route_to(handler)
    end
  end
end
