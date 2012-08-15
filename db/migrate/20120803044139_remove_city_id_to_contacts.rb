class RemoveCityIdToContacts < ActiveRecord::Migration
  def up
    remove_column :contacts, :city_id
  end

  def down
    add_column :contacts, :geoname_id, :string
  end
end
