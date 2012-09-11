class DropGeonameToJobs < ActiveRecord::Migration
  def up
    remove_column :jobs, :geoname
    remove_column :jobs, :geoname_id
  end

  def down
  end
end
