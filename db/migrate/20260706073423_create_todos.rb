class CreateTodos < ActiveRecord::Migration[8.1]
  def change
    create_table :todos do |t|
      t.references :todo_list, null: false, foreign_key: true
      t.string :task
      t.string :priority
      t.boolean :done

      t.timestamps
    end
  end
end
