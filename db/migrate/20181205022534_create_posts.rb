class CreatePosts < ActiveRecord::Migration[5.2]
  def change
    create_table :posts do |t|
      t.string :name, default: ""
      t.string :description, default: ""
      t.references :user, foreign_key: true, default: ""
      t.references :city, foreign_key: true, default: ""

      t.timestamps
    end
  end
end
