RSpec.describe '/api/books/:book_id/reviews' do
  let(:response_hash) { JSON(response.body, symbolize_names: true) }

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
  end
end
