class AddNoExperienceRequiredToJob < ActiveRecord::Migration
  def change
    add_column :jobs, :no_experience_required, :boolean, :default => false
  end
end
