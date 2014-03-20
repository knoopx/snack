class CreateFeeds < ActiveRecord::Migration
  def change
    create_table :feeds do |t|
      t.string :name
      t.string :url
      t.string :etag
      t.boolean :readability
      t.datetime :last_update_at
      t.timestamps
    end
  end
end
