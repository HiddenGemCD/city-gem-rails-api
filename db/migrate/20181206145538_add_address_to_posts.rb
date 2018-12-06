class AddAddressToPosts < ActiveRecord::Migration[5.2]
  def change
    add_column :posts, :address, :string, :default => ""
  end
end
