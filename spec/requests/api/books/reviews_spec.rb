RSpec.describe '/api/books/:book_id/reviews' do
  let(:response_hash) { JSON(response.body, symbolize_names: true) }

  describe 'GET to /' do
    it 'returns all reviews for a given book' do
      review = create(:review)

      get api_book_reviews_path(review.book)

      expect(response_hash).to eq(
        [
          {
            id: review.id,
            user_id: review.user_id,
            book_id: review.book_id,
            rating: review.rating,
            description: review.description,
            created_at: review.created_at.iso8601(3),
            updated_at: review.updated_at.iso8601(3),
          },
        ],
      )
    end
  end

  describe 'POST to /' do
    let(:book) { create(:book) }
    let(:user) { create(:user) }

    context 'when successful' do
      let(:params) do
        {
          rating: 3,
          user_id: user.id,
        }
      end

      it 'returns a 201 created status code' do
        post api_book_reviews_path(book), params: params

        expect(response).to have_http_status(:created)
      end

      it 'creates a review for a book' do
        expect do
          post api_book_reviews_path(book), params: params
        end.to change { Review.count }
      end

      it 'returns the created book review' do
        post api_book_reviews_path(book), params: params

        expect(response_hash).to include(params)
      end

      context 'with an optional review description' do
        let(:params) do
          {
            rating: 4,
            description: 'A positive review for a great book.',
            user_id: user.id,
          }
        end

        it 'returns the created book review with description' do
          post api_book_reviews_path(book), params: params

          expect(response_hash).to include(description: 'A positive review for a great book.')
        end
      end
    end

    context 'when unsuccessful' do
      it 'returns a 422 unprocessable entity status code' do
        params = {
          rating: 3,
          user_id: nil,
        }

        post api_book_reviews_path(book), params: params

        expect(response).to have_http_status(:unprocessable_entity)
      end

      context 'when missing a user ID' do
        let(:params) do
          {
            rating: 3,
            user_id: nil,
          }
        end

        it 'returns an error' do
          post api_book_reviews_path(book), params: params

          expect(response_hash).to include(errors: include('User can\'t be blank'))
        end
      end

      context 'with an invalid user ID' do
        let(:params) do
          {
            user_id: 100,
            rating: 3,
          }
        end

        it 'returns an error' do
          post api_book_reviews_path(book), params: params

          expect(response_hash).to include(errors: include('User must exist'))
        end
      end

      context 'with an invalid book ID' do
        let(:params) do
          {
            rating: 4,
            user_id: user.id,
          }
        end

        it 'returns a 404' do
          post api_book_reviews_path(-1), params: params

          expect(response).to have_http_status(:not_found)
        end
      end

      context 'with an invalid rating' do
        context 'with a missing rating' do
          let(:params) do
            {
              rating: nil,
              user_id: user.id,
            }
          end

          it 'returns an error' do
            post api_book_reviews_path(book), params: params

            expect(response_hash).to include(errors: include('Rating can\'t be blank'))
          end
        end

        context 'with a non-whole number rating' do
          let(:params) do
            {
              rating: -1,
              user_id: user.id,
            }
          end

          it 'returns an error' do
            post api_book_reviews_path(book), params: params

            expect(response_hash).to eq(errors: ['Rating must be greater than or equal to 1'])
          end
        end

        context 'with a non-number rating' do
          let(:params) do
            {
              rating: '⭐️',
              user_id: user.id,
            }
          end

          it 'returns an error' do
            post api_book_reviews_path(book), params: params

            expect(response_hash).to eq(errors: ['Rating is not a number'])
          end
        end

        context 'with a non-integer rating' do
          let(:params) do
            {
              rating: 2.5,
              user_id: user.id,
            }
          end

          it 'returns an error' do
            post api_book_reviews_path(book), params: params

            expect(response_hash).to eq(errors: ['Rating must be an integer'])
          end
        end

        context 'with a rating greater than 5' do
          let(:params) do
            {
              rating: 10,
              user_id: user.id,
            }
          end

          it 'returns an error' do
            post api_book_reviews_path(book), params: params

            expect(response_hash).to eq(errors: ['Rating must be less than or equal to 5'])
          end
        end

        context 'with a rating less than 1' do
          let(:params) do
            {
              rating: 0,
              user_id: user.id,
            }
          end

          it 'returns an error' do
            post api_book_reviews_path(book), params: params

            expect(response_hash).to eq(errors: ['Rating must be greater than or equal to 1'])
          end
        end
      end

      context 'when user has already reviewed book' do
        let(:params) do
          {
            user_id: user.id,
            rating: 4,
          }
        end

        before(:each) do
          create(:review, book: book, user: user)
        end

        it 'returns an error' do
          post api_book_reviews_path(book), params: params

          expect(response_hash).to eq(errors: ['User can only review a book once'])
        end
      end

      context 'when description contains profanity' do
        let(:params) do
          {
            user_id: user.id,
            rating: 1,
            description: 'This book is lame. The author sucks.',
          }
        end

        it 'returns an error' do
          post api_book_reviews_path(book), params: params

          expect(response_hash).to eq(errors: ['Description contains disallowed terms: lame and sucks'])
        end
      end
    end
  end
end
