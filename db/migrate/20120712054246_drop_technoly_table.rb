class DropTechnolyTable < ActiveRecord::Migration
  def up
  	drop_table :technologies
  end

  def down
  end
end
