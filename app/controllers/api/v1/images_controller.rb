module Api
  module V1
    class ImagesController < Api::ApiController
      before_action :set_image, only: [:show, :update, :destroy]
      respond_to :json

      def index
        @images = Image.all
        respond_with(@images)
      end

      def show
        respond_with(@image)
      end

      def create
        @image = Image.new(image_params)
        @image.save
        respond_with(@image)
      end

      def update
        @image.update(image_params)
        respond_with(@image)
      end

      def destroy
        @image.destroy
        respond_with(@image)
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
