class AddCourses < ActiveRecord::Migration[5.1]
  def change
    create_table :courses do |t|
      t.string :title, default: "Untitled", null: false
      t.references :users, index: true, null: false
      t.text :description, default: "No Description", null: false
      t.integer :visibility, index: true, null: false
      t.timestamps
    end
  end
end
