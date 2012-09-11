class RemoveCopyOfFromJobs < ActiveRecord::Migration
  def up
    remove_column :jobs, :copy_of
  end

  def down
    add_column :jobs, :copy_of, :string
  end
end
