module KeheWeeklyMcb
  class Base
    def deduction_rate_to_type(mcb_rate)
      mcb_rate_float = (mcb_rate.to_f) / 100
      (mcb_rate_float < 0.5) ? 'MCB' : 'Free Fill'
    end
  end
end
