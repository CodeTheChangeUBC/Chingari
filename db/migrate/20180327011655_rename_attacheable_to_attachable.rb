class RenameAttacheableToAttachable < ActiveRecord::Migration[5.1]
  def change
    remove_index :documents, name: :index_documents_on_attacheable_id_and_attacheable_type
    remove_index :embeds, name: :index_embeds_on_attacheable_id_and_attacheable_type
    remove_index :texts, name: :index_texts_on_attacheable_id_and_attacheable_type
    rename_column(:documents, :attacheable_id, :attachable_id)
    rename_column(:documents, :attacheable_type, :attachable_type)
    rename_column(:embeds, :attacheable_id, :attachable_id)
    rename_column(:embeds, :attacheable_type, :attachable_type)
    rename_column(:texts, :attacheable_id, :attachable_id)
    rename_column(:texts, :attacheable_type, :attachable_type)

    remove_index :documents, name: :index_documents_on_attachable_type_and_attachable_id
    remove_index :embeds, name: :index_embeds_on_attachable_type_and_attachable_id
    remove_index :texts, name: :index_texts_on_attachable_type_and_attachable_id

    add_index(:documents, [:attachable_type, :attachable_id], unique: true, name: "index_documents_on_attachable_type_and_attachable_id")
    add_index(:embeds, [:attachable_type, :attachable_id], unique: true, name: "index_embeds_on_attachable_type_and_attachable_id")
    add_index(:texts, [:attachable_type, :attachable_id], unique: true, name: "index_texts_on_attachable_type_and_attachable_id")
  end
end

