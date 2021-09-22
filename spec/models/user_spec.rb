RSpec.describe User do
  describe 'associations' do
    it { should have_many :reviews }
  end
end
