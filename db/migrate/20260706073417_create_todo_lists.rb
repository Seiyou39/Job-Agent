class CreateTodoLists < ActiveRecord::Migration[8.1]
  def change
    create_table :todo_lists do |t|
      t.string :title
      t.references :user, null: false, foreign_key: true
      t.integer :source

      t.timestamps
    end
  end
end
