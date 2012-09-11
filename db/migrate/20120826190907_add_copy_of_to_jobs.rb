class AddCopyOfToJobs < ActiveRecord::Migration
  def change
    add_column :jobs, :copy_of, :string
  end
end
