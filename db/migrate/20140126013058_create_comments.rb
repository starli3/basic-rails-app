class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.text :body     ## body column, text type
      t.references :post

      t.timestamps
    end
    add_index :comments, :post_id   ##This implies that we can look up which post each comment belongs it
  end
end


