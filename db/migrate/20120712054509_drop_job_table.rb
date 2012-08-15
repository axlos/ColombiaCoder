class DropJobTable < ActiveRecord::Migration
  def up
    drop_table :jobs
  end

  def down
  end
end
