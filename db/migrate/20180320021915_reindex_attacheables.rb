class ReindexAttacheables < ActiveRecord::Migration[5.1]
  def change
    remove_index(:documents, name: "index_documents_on_attacheable_and_attacheable_type")
    remove_index(:texts, name: "index_texts_on_attacheable_and_attacheable_type")
    remove_index(:embeds, name: "index_embeds_on_attacheable_and_attacheable_type")
  end
end
