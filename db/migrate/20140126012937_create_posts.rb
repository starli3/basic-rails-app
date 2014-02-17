class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :title
      t.text :body

      t.timestamps
    end
  end
end

## t is dummy variable. Representing table in this case. new table has title, body, timestamp

## change method, up/down method, reverse method - http://guides.rubyonrails.org/migrations.html

