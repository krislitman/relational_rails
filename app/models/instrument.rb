class Instrument < ApplicationRecord
  validates_presence_of :brand
  belongs_to :dealer, counter_cache: true

  def self.all_on_sale
    where(on_sale: true)
  end

  def self.filter_price(amount)
    where('price > ?', amount)
  end

  def self.order_by_name
    order(:name)
  end
end
