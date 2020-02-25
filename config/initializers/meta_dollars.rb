class String
  def to_dollars
    str_amount = self
    amount = str_amount.to_s.try(:gsub,/(\,|\$|\s)/,'')
    dollar_cent_split = amount.try(:split, /(\.|\s)/)
    cents_str = dollar_cent_split.try(:length) == 3 ? dollar_cent_split.try(:last) : 0
    cents_str += '0' if cents_str.try(:gsub, /\W*/i, '').try(:length) == 1
    cents_str = cents_str.try(:scan, /^\d{2}/).try(:first)
    dollar_str = dollar_cent_split.try(:first).try(:gsub, /\W*/i, '') || 0
    return '' if !cents_str && !dollar_str
    (dollar_str.to_f) + (cents_str.to_f / 100)
  end
end

class NilClass
  def to_dollars
    self.to_s.to_dollars
  end
end

class Numeric # Float, Integer
  def to_dollars
    self.to_s.to_dollars
  end
end
