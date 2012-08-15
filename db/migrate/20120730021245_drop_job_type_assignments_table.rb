class DropJobTypeAssignmentsTable < ActiveRecord::Migration
  def up
    drop_table :job_type_assignments
  end

  def down
  end
end
