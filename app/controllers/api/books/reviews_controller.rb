module API
  module Books
    class ReviewsController < ApplicationController
      def create
        book = find_book
        review = book.reviews.new(allowed_params)

        if review.save
          render json: review, status: :created
        else
          render json: { errors: review.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def index
        book = find_book

        render json: book.reviews
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
