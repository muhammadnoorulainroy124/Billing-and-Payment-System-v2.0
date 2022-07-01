module PlansUtilityModule

  extend ActiveSupport::Concern

  def self.calculate_monthly_charges (feature_ids)
    total = 0
    feature_ids.each do |index|
      next if index == ""
      puts "index is #{index}"
      price = Featrue.where("id = ?", index.to_i).pluck(:unit_price)

      puts "price is #{price.first}"
      total = total + price.first #!= nil ? total + price.first : total + 0
    end
    puts "total is #{total}"
    return total
  end
end
