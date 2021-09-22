RSpec.describe Review do
  describe 'associations' do
    it { should belong_to :book }
    it { should belong_to :user }
  end

  describe 'validations' do
    subject { build(:review) }

    it { should validate_presence_of :user_id }
    it { should validate_presence_of :rating }

    it do
      should validate_uniqueness_of(:user_id).
        scoped_to(:book_id).
        with_message('can only review a book once')
    end

    it do
      should validate_numericality_of(:rating).
        is_less_than_or_equal_to(5).
        is_greater_than_or_equal_to(1).
        only_integer
    end

    describe '#no_profanity_in_description' do
      context 'with no description present' do
        subject { build_stubbed(:review) }

        it { is_expected.to be_valid }
      end

      context 'when description does not contain profanity' do
        subject { build_stubbed(:review, :with_description) }

        it { is_expected.to be_valid }
      end

      context 'when description contains profanity' do
        subject { build_stubbed(:review, :with_profane_description) }

        it { is_expected.to be_invalid }

        it 'returns an error with a list of disallowed terms' do
          subject.valid?

          expect(subject.errors.full_messages).to include('Description contains disallowed terms: lame and sucks')
        end
      end
    end
  end
end
