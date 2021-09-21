module API
  module Books
    class ReviewsController < ApplicationController
      def create
        book = find_book
        review = book.reviews.new(allowed_params)

        if review.save
          render json: review
        else
          render json: { errors: review.errors.full_messages }
        end
      end

      private

      def find_book
        @_find_book ||= Book.find(params[:book_id])
      end

      def allowed_params
        params.permit(
          :rating,
          :description,
          :user_id,
        )
      end
    end
  end
end
