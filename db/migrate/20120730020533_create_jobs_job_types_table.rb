class CreateJobsJobTypesTable < ActiveRecord::Migration
  def up
    create_table :jobs_job_types, :id => false do |t|
      t.references :job
      t.references :job_type
    end
    add_index :jobs_job_types, [:job_id, :job_type_id]
    add_index :jobs_job_types, [:job_type_id, :job_id]
  end

  def down
  end
end
