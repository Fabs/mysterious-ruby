module Api
  module V1
    class ImagesController < Api::ApiController
      prepend_before_action :authenticate!, except: [:index]
      before_action :set_image, only: [:show, :update, :destroy]
      respond_to :json

      api :GET, '/v1/images', 'Gets all images'
      api_version '1'
      def index
        @images = Image.all
        respond_with(@images)
      end

      api :GET, '/v1/images/:id', 'Shows a singular image by :id'
      api_version '1'
      def show
        respond_with(:api, :v1, @image)
      end

      api :POST, '/v1/images', 'Creates an image'
      param :image, Hash, 'The image to be created', required: true do
        param :url, String, 'The image url'
      end
      api_version '1'
      def create
        signed_in? or return

        @image = Image.new(image_params.merge(user: current_user))
        if @image.save
          render :show, status: :created
        else
          render json: { errors: @image.errors }, status: :unprocessable_entity
        end
      end

      api :PATCH, '/v1/images/:id', 'Updates the image with :id'
      api_version '1'
      param :image, Hash, 'The image values to be updated', required: true do
        param :url, String, 'The new image url'
      end
      def update
        assert_ownership(@image) or return

        if @image.update(image_params)
          head :no_content
        else
          render json: { errors: @image.errors }, status: :unprocessable_entity
        end
      end

      api :PATCH, '/v1/images/:id', 'Destroys the image with :id'
      api_version '1'
      def destroy
        assert_ownership(@image) or return

        @image.destroy
        respond_with(:api, :v1, @image)
      end

      private

      def set_image
        @image = Image.find(params[:id])
      end

      def image_params
        params.require(:image).permit(:url)
      end
    end
  end
end
