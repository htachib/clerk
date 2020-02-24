require 'rails_helper'

# meta programming to ease conversion of stringified numbers from documents
describe 'meta_dollars.rb' do
  it 'should convert string to dollar amount' do
    expect("501.137".to_dollars).to eql 501.13
  end

  it 'should convert nil to rounded dollar amount' do
    expect(nil.to_dollars).to eql 0.0
  end

  it 'should convert float to dollar amount with rounded cents' do
    expect(50.198.to_dollars).to eql 50.19
  end

  it 'should convert integer to rouded dollar amount' do
    expect(25.to_dollars).to eql 25.0
  end
end
