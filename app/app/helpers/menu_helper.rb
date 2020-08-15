module MenuHelper

  def currency_symbol(curr_str = :inr)
    curr = Spree::Config.available_currencies.select{|currency| currency.id == curr_str.downcase.to_sym}.try(:first)
    curr.symbol
  end

end