class CreateLogs < ActiveRecord::Migration
  def self.up
    create_table :logs do |t|
      t.string    :name
      t.text      :comment
      t.timestamps
    end
  end

  def self.down
    drop_table :logs
  end
end
