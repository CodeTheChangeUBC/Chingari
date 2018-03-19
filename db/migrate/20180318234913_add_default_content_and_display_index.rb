class AddDefaultContentAndDisplayIndex < ActiveRecord::Migration[5.1]
  def change
    change_column_null(:texts, :content, false)
    change_column_default(:texts, :content, "")
    change_column_null(:embeds, :content, false)
    change_column_default(:embeds, :content, "")
    change_column_null(:files, :display_index, false)
    change_column_default(:files, :display_index, 0)
    change_column_null(:embeds, :display_index, false)
    change_column_default(:embeds, :display_index, 0)
    change_column_null(:texts, :display_index, false)
    change_column_default(:texts, :display_index, 0)
  end
end
