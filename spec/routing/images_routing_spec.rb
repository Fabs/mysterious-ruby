require 'rails_helper'

RSpec.describe Api::V1::ImagesController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      path = 'v1/images'
      handler = 'api/v1/images#index'
      expect(get: path, format: 'json').to route_to(handler)
    end

    it 'routes to #show' do
      path = 'v1/images/1'
      handler = 'api/v1/images#show'
      expect(get: path, format: 'json').to route_to(handler, id: '1')
    end

    it 'routes to #create' do
      path = 'v1/images'
      handler = 'api/v1/images#create'
      expect(post: path, format: 'json').to route_to(handler)
    end

    it 'routes to #update via PUT' do
      path = 'v1/images/1'
      handler = 'api/v1/images#update'
      expect(put: path, format: 'json').to route_to(handler, id: '1')
    end

    it 'routes to #update via PATCH' do
      path = 'v1/images/1'
      handler = 'api/v1/images#update'
      expect(patch: path, format: 'json').to route_to(handler, id: '1')
    end

    it 'routes to #destroy' do
      path = 'v1/images/1'
      handler = 'api/v1/images#destroy'
      expect(delete: path, format: 'json').to route_to(handler, id: '1')
    end
  end
end
