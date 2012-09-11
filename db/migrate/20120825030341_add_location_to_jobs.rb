class AddLocationToJobs < ActiveRecord::Migration
  def change
    add_column :jobs, :location, :string, :null => false, :default => ''
  end
end
