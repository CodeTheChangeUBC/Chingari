class CreateEmbeds < ActiveRecord::Migration[5.1]
  def change
    create_table :embeds do |t|
      t.references :user, null: false
      t.references :attacheable, null: false, polymorphic: true
      t.text :content
      t.integer :display_index
    end
    add_index(:embeds, [:attacheable_id, :attacheable_type], name: "index_embeds_on_attacheable_id_and_attacheable_type")
  end
end
