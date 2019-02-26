require 'rails_helper'

RSpec.describe Document, type: :model do
  subject { build(:document) }

  it 'has a valid factory' do
    expect(subject).to be_valid
  end

  describe 'ActiveModel validations' do

  end

  describe 'ActiveRecord associations' do
    it { expect(subject).to belong_to(:parser) }
  end
end
