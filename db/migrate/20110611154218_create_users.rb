class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username
      t.string :name
      t.string :password_digest
      t.boolean :is_admin, :default => false
      t.datetime :last_login_at
      t.string :distance_units
      t.timestamps
    end

    add_index :users, :username
    User.create :username => "admin", :password => "admin", :is_admin => true
  end
end
