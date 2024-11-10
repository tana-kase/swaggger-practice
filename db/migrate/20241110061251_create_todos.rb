class CreateTodos < ActiveRecord::Migration[7.0]
  def up
    sql = File.read('db/sql/001_create_todos.sql')
    execute sql
  end

  def down
    drop_table :todos
  end
end