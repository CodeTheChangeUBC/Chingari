class CreateFiles < ActiveRecord::Migration[5.1]
  def change
    create_table :files do |t|
      t.string :title, default: "Untitled", null: false
      t.references :user, null: false, index: true
      t.references :attacheable, null: false, polymorphic: true
      t.integer :display_index
    end
    add_index(:files, [:attacheable, :attacheable_type])
  end
end
