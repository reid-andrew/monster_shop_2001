class Cart
  attr_reader :contents

  def initialize(contents)
    @contents = contents
  end

  def add_item(item)
    @contents[item] = 0 if !@contents[item]
    @contents[item] += 1
  end

  def total_items
    @contents.values.sum
  end

  def items
    item_quantity = {}
    @contents.each do |item_id,quantity|
      item_quantity[Item.find(item_id)] = quantity
    end
    item_quantity
  end

  def subtotal(item)
    discount = item.merchant.discount_eligible(@contents[item.id.to_s], item.price)
    (item.price - discount) * @contents[item.id.to_s]
  end

  def total
    @contents.sum do |item_id,quantity|
      subtotal(Item.find(item_id))
    end
  end

  def limit_reached?(item_id)
    @contents[item_id] == Item.find(item_id).inventory
  end

  def quantity_zero?(item_id)
    Item.find(item_id).inventory == 0
  end

  def add_quantity(item_id)
    @contents[item_id] += 1 unless limit_reached?(item_id)
  end

  def subtract_quantity(item_id)
    @contents[item_id] -= 1 unless quantity_zero?(item_id)
  end
end
