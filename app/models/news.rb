class News < ActiveRecord::Base
  has_many :products, foreign_key: :news_item_id, class_name: 'Spree::Product'
  accepts_nested_attributes_for :products
end
