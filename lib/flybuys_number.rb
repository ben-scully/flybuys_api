# frozen_string_literal: true

class FlybuysNumber
  class << self
    def valid_number?(number_as_str)
      reversed_number = number_as_str.reverse.split('')

      doubled_and_untouched = reversed_number.map.with_index do |char, index|
        index.odd? ? (char.to_i * 2) : char.to_i
      end

      total = doubled_and_untouched.join.split('').map(&:to_i).sum
      (total % 10).zero?
    end

    def validation_string(raw_number_as_str)
      number_as_str = sanitize(raw_number_as_str)
      type = card_type(number_as_str)
      valid = valid_number?(number_as_str) ? 'valid' : 'invalid'

      "#{type}: #{number_as_str} (#{valid})"
    end

    def card_type(number_as_str)
      is_type_green = ->(val) { card_type_green?(val) }

      case number_as_str
      when /^60141(\d{11,12})$/
        'Fly Buys Black'
      when /^6014352(\d{9})$/
        'Fly Buys Red'
      when is_type_green
        'Fly Buys Green'
      when /^6014(\d{12})$/
        'Fly Buys Blue'
      else
        'Unknown'
      end
    end

    def card_type_green?(number_as_str)
      return unless number_as_str.match(/^60143(\d{11})$/)

      ten_digits = number_as_str[0..9].to_i
      ten_digits.between?(6014355526, 6014355529)
    end

    def sanitize(raw_number_as_str)
      raw_number_as_str.gsub(' ', '')
    end
  end
end
