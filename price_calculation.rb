require './models/campaign.rb'
require './models/order.rb'

# 計算規則
#
# 1. 消費未滿 $1,500, 則須增加 $60 運費
# 2. 若消費期間有超過兩個優惠活動，取最優者折扣 
# 3. 運費計算在優惠折抵之後
#
# Please implemenet the following methods.
# Additional helper methods are recommended.

class PriceCalculation
  def initialize(order_id)
    @order = Order.find(order_id)
    raise Order::NotFound unless @order
    @campaigns = Campaign.running_campaigns(@order.order_date)
  end

  def total
    total_price = @order.price

    if @campaigns.any?
      max_discount = @campaigns.map(&:discount_ratio).max
      total_price -= (total_price * max_discount / 100).round
    end

    total_price += 60 if total_price < 1500
    total_price
  end

  def free_shipment?
    total > 1500
  end
end
