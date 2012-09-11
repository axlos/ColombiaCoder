class DropGeonameToContacts < ActiveRecord::Migration
  def up
    remove_column :contacts, :geoname
    remove_column :contacts, :geoname_id
  end

  def down
  end
end
