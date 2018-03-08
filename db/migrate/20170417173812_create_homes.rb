class CreateHomes < ActiveRecord::Migration[5.0]
  def change
    create_table :homes do |t|
      t.Home :title
      t.Home :note

      t.timestamps
    end
  end
end
