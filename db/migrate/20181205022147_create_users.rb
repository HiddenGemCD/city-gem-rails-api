class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :name
      t.string :city
      t.string :gender
      t.string :avatar_url
      t.string :intro
      t.string :open_id

      t.timestamps
    end
  end
end
