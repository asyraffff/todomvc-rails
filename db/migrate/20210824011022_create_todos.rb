class CreateTodos < ActiveRecord::Migration[6.1]
  def change
    create_table :todos do |t|
      t.string :title, null: false
      t.boolean :completed, default: false, null: false

      t.timestamps
    end
    add_index :todos, :completed
  end
end
