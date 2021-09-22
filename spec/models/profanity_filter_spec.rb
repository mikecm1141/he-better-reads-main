RSpec.describe ProfanityFilter do
  subject(:profanity_filter) { described_class.new(text) }

  let(:clean_text) { 'Some very fine and clean text.' }
  let(:profane_text) { 'This is lame and it SUCKS!' }

  describe '#filtered_terms' do
    subject { profanity_filter.filtered_terms }

    context 'when given text contains profanity' do
      let(:text) { profane_text }

      it 'returns an array of terms found' do
        expect(subject).to contain_exactly('lame', 'sucks')
      end
    end

    context 'when given text is clean' do
      let(:text) { clean_text }

      it 'returns an empty array' do
        expect(subject).to be_empty
      end
    end
  end

  describe '#clean?' do
    subject { profanity_filter.clean? }

    context 'when given text contains profanity' do
      let(:text) { profane_text }

      it { is_expected.to be false }
    end

    context 'when given text is clean' do
      let(:text) { clean_text }

      it { is_expected.to be true}
    end
  end
end
