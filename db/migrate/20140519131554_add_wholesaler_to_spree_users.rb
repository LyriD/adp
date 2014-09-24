class AddWholesalerToSpreeUsers < ActiveRecord::Migration
  def change
    add_column :spree_users, :wholesaler, :boolean
  end
end
