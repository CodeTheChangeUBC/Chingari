class CreateTexts < ActiveRecord::Migration[5.1]
  def change
    create_table :texts do |t|
      t.references :user, null: false
      t.references :attacheable, null: false, polymorphic: true
      t.text :content
      t.integer :display_index
    end
    add_index(:texts, [:attacheable_id, :attacheable_type])
  end
end
