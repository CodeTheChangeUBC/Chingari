class Reindex < ActiveRecord::Migration[5.1]
  def change
    remove_index :embeds, name: "index_documents_on_attachable_display_index"
    remove_index :documents, name: "index_embeds_on_attachable_display_index"
    remove_index :texts, name: "index_texts_on_attachable_display_index"
    add_index(:documents, [:attachable_type, :attachable_id, :display_index], name: "index_documents_on_attachable_display_index")
    add_index(:embeds, [:attachable_type, :attachable_id, :display_index], name: "index_embeds_on_attachable_display_index")
    add_index(:texts, [:attachable_type, :attachable_id, :display_index], name: "index_texts_on_attachable_display_index")
  end
end
