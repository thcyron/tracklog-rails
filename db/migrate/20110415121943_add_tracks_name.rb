class AddTracksName < ActiveRecord::Migration
  def self.up
    add_column :tracks, :name, :string
  end

  def self.down
    remove_column :tracks, :name
  end
end
