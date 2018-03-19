class UniqueEnrollment < ActiveRecord::Migration[5.1]
  def change
    add_index(:enrollments, [:user_id, :course_id], unique: true)
    change_column_null(:enrollments, :user_id, false)
    change_column_null(:enrollments, :course_id, false)    
  end
end
