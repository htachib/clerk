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

  it 'should convert integer to rounded dollar amount' do
    expect(25.to_dollars).to eql 25.0
  end

  it 'should convert string with $ to rounded dollar amount' do
    expect('$25.90'.to_dollars).to eql 25.9
    expect('$25.91'.to_dollars).to eql 25.91
  end

  it 'should convert dollar or amount string surrounded by special characters and text to rounded dollar amount' do
    expect('$25.90||23'.to_dollars).to eql 25.9
    expect('25.90|&23'.to_dollars).to eql 25.9
  end
end
