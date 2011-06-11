class AddUserIdToLogs < ActiveRecord::Migration
  def change
    add_column :logs, :user_id, :integer
    Log.update_all(:user_id => 1)
  end
end
