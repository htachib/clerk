require 'rails_helper'

RSpec.describe Parser, type: :model do
  subject { build(:parser) }

  it 'has a valid factory' do
    expect(subject).to be_valid
  end

  describe 'ActiveModel validations' do

  end

  describe 'ActiveRecord associations' do
    it { expect(subject).to belong_to(:user) }
    it { expect(subject).to have_many(:documents) }
  end
end
