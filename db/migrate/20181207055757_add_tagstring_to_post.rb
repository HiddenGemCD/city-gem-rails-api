class AddTagstringToPost < ActiveRecord::Migration[5.2]
  def change
    add_column :posts, :tagstring, :string
  end
end
