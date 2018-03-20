class CreateEmbeds < ActiveRecord::Migration[5.1]
  def change
    create_table :embeds do |t|
      t.references :user, null: false
      t.references :attachable, null: false, polymorphic: true
      t.text :content
      t.integer :display_index
    end
    add_index(:embeds, [:attachable, :attachable_type], name: "index_embeds_on_attachable_and_attachable_type")
  end
end
