class RemoveCityIdToJobs < ActiveRecord::Migration
  def up
    remove_column :jobs, :city_id
  end

  def down
  end
end
