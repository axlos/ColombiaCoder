class DropCountriesTable < ActiveRecord::Migration
  def up
    drop_table :countries
  end

  def down
  end
end
