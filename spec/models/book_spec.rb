RSpec.describe Book do
  describe 'associations' do
    it { should have_many :reviews }
  end
end
