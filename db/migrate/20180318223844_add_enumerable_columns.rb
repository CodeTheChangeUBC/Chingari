class AddEnumerableColumns < ActiveRecord::Migration[5.1]
  def change
    add_column(:users, :tier, :integer, default: 0, null: false, index: true)
    add_column(:courses, :tier, :integer, default: 0, null: false, index: true)
    change_column_default(:users, :username, 'Anonymous')
    change_column_null(:users, :username, false)
    change_column_null(:users, :password_digest, false)
    change_column_default(:courses, :visibility, 0)
    change_column_null(:courses, :visibility, false)
    change_column_default(:users, :role, 0)
    change_column_null(:users, :role, false)
    add_index(:users, :role)
  end
end
