require "rails_helper"

RSpec.describe Api::V1::ScoresController, type: :routing do
  describe "routing" do
    it "routes to #create" do
      path = 'v1/images/2/scores'
      handler = 'api/v1/scores#index'
      expect(get: path, format: 'json').to route_to(handler, image_id: "2")
    end

    it "routes to #create" do
      path = 'v1/images/2/scores'
      handler = 'api/v1/scores#create'
      expect(post: path, format: 'json').to route_to(handler, image_id: "2")
    end

    it "routes to #update via PUT" do
      path = 'v1/images/2/scores/1'
      handler = 'api/v1/scores#update'
      expect(put: path, format: 'json').to route_to(handler, id: "1",
                                                    image_id: "2")
    end

    it "routes to #update via PATCH" do
      path = 'v1/images/2/scores/1'
      handler = 'api/v1/scores#update'
      expect(patch: path, format: 'json').to route_to(handler, id: "1",
                                                      image_id: "2")
    end
  end
end
