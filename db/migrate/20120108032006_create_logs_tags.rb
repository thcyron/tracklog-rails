class CreateLogsTags < ActiveRecord::Migration
  def change
    create_table :logs_tags, id: false do |t|
      t.integer :log_id, null: false
      t.integer :tag_id, null: false
    end
  end
end
