class DropFiles < ActiveRecord::Migration[5.1]
  def change
    drop_table :files
    create_table :documents do |t|
      t.string :title, default: "Untitled", null: false
      t.references :user, null: false, index: true
      t.references :attachable, null: false, polymorphic: true
      t.integer :display_index
    end
    add_index(:documents, [:attachable_id, :attachable_type], name: "index_documents_on_attachable_and_attachable_type")
  end
end
