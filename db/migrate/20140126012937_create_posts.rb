class CreatePosts < ActiveRecord::Migration
  def change    #The change method signifies that a database change will happen as a result of running the method
    create_table :posts do |t|    #The create_table method takes a Symbol argument which represents the table name, and a block argument that contains the details to be added to the table
      t.string :title
      t.text :body

      t.timestamps
    end
  end
end

## t is dummy variable. Representing table in this case. new table has title, body, timestamp

## change method, up/down method, reverse method - http://guides.rubyonrails.org/migrations.html

