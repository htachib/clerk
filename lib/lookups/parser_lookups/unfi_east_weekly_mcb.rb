module UnfiEastWeeklyMcb
  class Base
    def deduction_description_rate_to_type(mcb_rate, deduction_description)
      sanitized_description = deduction_description.downcase.gsub(/\s+/, '')
      mcb_rate_float = (mcb_rate.to_f) / 100
      if sanitized_description.include?('openingorder')
        return 'Free Fill'
      elsif sanitized_description.include?('samples')
        return 'Samples'
      elsif mcb_rate_float < 0.5
        return 'MCB'
      elsif mcb_rate_float >= 0.5
        return 'Free Fill'
      else
        return 'Undetermined'
      end
    end
  end
end
