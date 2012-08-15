class CreateJobTypesJobs < ActiveRecord::Migration
  def up
    create_table :job_types_jobs, :id => false do |t|
      t.references :job
      t.references :job_type
    end
    add_index :job_types_jobs, [:job_id, :job_type_id]
    add_index :job_types_jobs, [:job_type_id, :job_id]
  end

  def down
    drop_table :jobs_job_types
  end
end
