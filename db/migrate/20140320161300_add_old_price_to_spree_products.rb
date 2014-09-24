class AddOldPriceToSpreeProducts < ActiveRecord::Migration
  def change
    add_column :spree_products, :old_price, :string
  end
end
