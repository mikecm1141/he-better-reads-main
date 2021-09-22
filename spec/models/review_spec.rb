RSpec.describe Review do
  describe 'validations' do
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
