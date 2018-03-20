class CreateTexts < ActiveRecord::Migration[5.1]
  def change
    create_table :texts do |t|
      t.references :user, null: false
      t.references :attachable, null: false, polymorphic: true
      t.text :content
      t.integer :display_index
    end
    add_index(:texts, [:attachable, :attachable_type], name: "index_texts_on_attachable_and_attachable_type")
  end
end
