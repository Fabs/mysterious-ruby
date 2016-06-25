require "rails_helper"

RSpec.describe Api::V1::SessionsController, type: :routing do
  describe "routing" do
    it 'routes to #sign_in' do
      handler = 'api/v1/sessions#sign_in'
      expect(post: 'v1/sessions/sign_in', format: 'json').to route_to(handler)
    end

    it 'routes to #sign_off' do
      handler = 'api/v1/sessions#sign_off'
      expect(post: 'v1/sessions/sign_off', format: 'json').to route_to(handler)
    end
  end
end
