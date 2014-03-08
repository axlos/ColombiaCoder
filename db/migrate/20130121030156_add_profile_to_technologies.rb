class AddProfileToTechnologies < ActiveRecord::Migration
  def change
    add_column :technologies, :profile_id, :integer
    add_index :technologies, :profile_id
  end
end
