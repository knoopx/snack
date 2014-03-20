class CreateEntries < ActiveRecord::Migration
  def change
    create_table :entries do |t|
      t.string :title
      t.string :url
      t.text :body
      t.text :excerpt
      t.integer :word_count
      t.string :author
      t.belongs_to :feed, index: true
      t.timestamps
    end
  end
end
