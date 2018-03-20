class Reindexattachables < ActiveRecord::Migration[5.1]
  def change
    remove_index(:documents, name: "index_documents_on_attachable_and_attachable_type")
    remove_index(:texts, name: "index_texts_on_attachable_and_attachable_type")
    remove_index(:embeds, name: "index_embeds_on_attachable_and_attachable_type")
  end
end
