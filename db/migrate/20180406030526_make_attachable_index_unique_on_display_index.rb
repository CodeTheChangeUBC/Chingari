class MakeAttachableIndexUniqueOnDisplayIndex < ActiveRecord::Migration[5.1]
  def change
    remove_index :embeds, name: :index_embeds_on_attachable_type_and_attachable_id
    remove_index :documents, name: :index_documents_on_attachable_type_and_attachable_id
    remove_index :texts, name: :index_texts_on_attachable_type_and_attachable_id
    add_index(:documents, [:attachable_type, :attachable_id, :display_index], unique: true, name: "index_documents_on_attachable_display_index")
    add_index(:embeds, [:attachable_type, :attachable_id, :display_index], unique: true, name: "index_embeds_on_attachable_display_index")
    add_index(:texts, [:attachable_type, :attachable_id, :display_index], unique: true, name: "index_texts_on_attachable_display_index")
  end
end
