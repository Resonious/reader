class CreateBooks < ActiveRecord::Migration[6.1]
  def change
    create_table :books do |t|
      t.string :slug, null: false
      t.string :name, null: false
      t.text :content, null: false
      t.bigint :idx, default: 0, null: false

      t.timestamps
    end

    add_index :books, :slug, unique: true
  end
end
