module Api
  module V1
    class ScoresController < Api::ApiController
      before_action :set_image
      prepend_before_action :authenticate!, except: [:index]
      respond_to :json

      api :POST, '/v1/images/:image_id/scores',
          'Assigns a score 0..4 on the image, from this user'
      param :score, Hash, 'The image to be created', required: true do
        param :value, Numeric, 'The score value from 0..4'
      end
      api_version '1'
      def create
        signed_in? || return

        new_params = score_params.merge(user: current_user, image: @image)
        @score = Score.new(new_params)
        if @score.save
          render :show, status: :created
        else
          render json: { errors: @score.errors }, status: :unprocessable_entity
        end
      end

      api :PATCH, '/v1/images/:image_id/scores/:id',
          'Updates the score :id from the image :image_id'
      api_version '1'
      param :score, Hash, 'The image to be created', required: true do
        param :value, Numeric, 'The score value from 0..4'
      end
      def update
        @score = Score.find(params[:id])
        assert_ownership(@score) || return

        if score_params.any? && @score.update(score_params)
          head :no_content
        else
          render json: { errors: @image.errors }, status: :unprocessable_entity
        end
      end

      private

      def set_image
        @image = Image.find_by(id: params[:image_id])
        render json: image_not_found, status: :not_found unless @image
      end

      def image_not_found
        { errors: "Can' find image with id=`#{params[:image_id]}`" }
      end

      def score_params
        params.require(:score).permit(:value)
      end
    end
  end
end
