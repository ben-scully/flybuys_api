# frozen_string_literal: true

require './lib/flybuys_number'

def inputs
  <<~HEREDOC.split("\n")
    60141016700078611
    6014152705006141
    6014111100033006
    6014709045001234
    6014352700000140
    6014355526000020
    6014 3555 2900 0028
    6013111111111111
  HEREDOC
end

def expected_results
  <<~HEREDOC.split("\n")
    Fly Buys Black: 60141016700078611 (valid)
    Fly Buys Black: 6014152705006141 (invalid)
    Fly Buys Black: 6014111100033006 (valid)
    Fly Buys Blue: 6014709045001234 (valid)
    Fly Buys Red: 6014352700000140 (valid)
    Fly Buys Green: 6014355526000020 (valid)
    Fly Buys Green: 6014355526000028 (invalid)
    Unknown: 6013111111111111 (invalid)
  HEREDOC
end

RSpec.describe FlybuysNumber do
  describe '#validation_string' do
    inputs.each_with_index do |input, index|
      expected_result = expected_results[index]

      it "input: #{input} matches expected_result: #{expected_result}" do
        expect(described_class.validation_string(input)).to eq(expected_result)
      end
    end
  end

  describe '#card_type' do
    inputs.each_with_index do |input, index|
      expected_result = expected_results[index].match(/^(.*):/)[1]
      input = described_class.sanitize(input)

      it "input: #{input} matches expected_result: #{expected_result}" do
        expect(described_class.card_type(input)).to eq(expected_result)
      end
    end
  end

  describe '#valid_number?' do
    inputs.each_with_index do |input, index|
      expected_result = expected_results[index].match(/^.*:.*\((.*)\)/)[1].gsub(' ', '')
      expected_result = expected_result == 'valid'
      input = described_class.sanitize(input)

      it "input: #{input} matches expected_result: #{expected_result}" do
        expect(described_class.valid_number?(input)).to eq(expected_result)
      end
    end
  end
end
