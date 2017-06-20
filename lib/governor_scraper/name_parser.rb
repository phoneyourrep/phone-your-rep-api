# frozen_string_literal: true

class GovernorScraper
  class NameParser
    attr_reader :official_full, :first, :last, :middle, :nickname, :suffix

    def initialize(official_full)
      @official_full = official_full
    end

    def parse
      split_name
      [first, last, middle, nickname, suffix]
    end

    def name_array
      @_name_array ||= official_full.split(' ')
    end

    def split_name
      detect_nickname
      detect_suffix
      if name_array.length == 2
        set_first_and_last
      elsif name_array[0].include?('.') && name_array[1].include?('.')
        set_name_with_initialed_first
      elsif name_array.length >= 3
        set_first_last_and_middle
      end
    end

    def set_first_and_last
      @first = name_array.first
      @last  = name_array.last
    end

    def set_name_with_initialed_first
      @first  = "#{name_array.shift} #{name_array.shift}"
      @last   = name_array.pop
      @middle = name_array.pop
    end

    def set_first_last_and_middle
      @first  = name_array.shift
      @last   = name_array.pop
      @middle = name_array.join(' ')
    end

    def detect_nickname
      @nickname = name_array.detect { |name| name.include?('"') }
      name_array.reject! { |name| name.include?('"') }
    end

    def detect_suffix
      @suffix = if name_array[-2].include?(',')
                  name_array[-2].delete(',')
                  name_array.pop
                end
    end
  end
end
