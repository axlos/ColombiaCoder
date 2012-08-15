class RemoveExperienceRequiredToJob < ActiveRecord::Migration
  def up
    remove_column :jobs, :experience_required
  end

  def down
  end
end
