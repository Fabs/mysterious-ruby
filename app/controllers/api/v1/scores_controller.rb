module Api
  module V1
    class ScoresController < ApplicationController
      before_action :set_score, only: [:show, :update]
      respond_to :json

      def index
        @scores = Score.all
        respond_with(@scores)
      end

      def create
        @score = Score.new(score_params)
        @score.save
        respond_with(@score)
      end

      def update
        @score.update(score_params)
        respond_with(@score)
      end

      private

      def set_score
        @score = Score.find(params[:id])
      end

      def score_params
        params.require(:score).permit(:value)
      end
    end
  end
end
