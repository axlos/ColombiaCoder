class DropCitiesTable < ActiveRecord::Migration
  def up
    drop_table :cities
  end

  def down
  end
end
