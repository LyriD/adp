class AddNewsItemIdToSpreeProducts < ActiveRecord::Migration
  def change
    add_column :spree_products, :news_item_id, :integer
  end
end
