require 'rails_helper'

RSpec.describe ParseMapException, type: :model do
  subject { build(:parse_map_exception) }

  it 'has a valid factory' do
    expect(subject).to be_valid
  end

  describe 'ActiveModel validations' do
    it { expect(subject).to validate_presence_of(:parser_id) }
  end

  describe 'ActiveRecord associations' do
    it { expect(subject).to belong_to(:parser) }
  end

  describe 'callbacks' do
    it 'should send admin an email after created' do
      expect {
        subject.save
      }.to change {
        ActionMailer::Base.deliveries.count
      }.by 1
    end
  end
end
