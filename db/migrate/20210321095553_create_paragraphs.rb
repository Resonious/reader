class CreateParagraphs < ActiveRecord::Migration[6.1]
  def change
    create_table :paragraphs do |t|
      t.references :book, index: true
      t.text :content
      t.integer :index, null: false, default: 0

      t.timestamps
    end
  end
end
