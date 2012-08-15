require 'test_helper'

class JobsControllerTest < ActionController::TestCase
  setup do
    @job = jobs(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:jobs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create job" do
    assert_difference('Job.count') do
      post :create, job: { application_details: @job.application_details, company_description: @job.company_description, company_logo_image_url: @job.company_logo_image_url, company_name: @job.company_name, company_web_site: @job.company_web_site, email_address: @job.email_address, experience_required: @job.experience_required, job_description: @job.job_description, job_title: @job.job_title, resume_directly: @job.resume_directly, salary_negotiable: @job.salary_negotiable, salary_range_fin: @job.salary_range_fin, salary_range_ini: @job.salary_range_ini }
    end

    assert_redirected_to job_path(assigns(:job))
  end

  test "should show job" do
    get :show, id: @job
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @job
    assert_response :success
  end

  test "should update job" do
    put :update, id: @job, job: { application_details: @job.application_details, company_description: @job.company_description, company_logo_image_url: @job.company_logo_image_url, company_name: @job.company_name, company_web_site: @job.company_web_site, email_address: @job.email_address, experience_required: @job.experience_required, job_description: @job.job_description, job_title: @job.job_title, resume_directly: @job.resume_directly, salary_negotiable: @job.salary_negotiable, salary_range_fin: @job.salary_range_fin, salary_range_ini: @job.salary_range_ini }
    assert_redirected_to job_path(assigns(:job))
  end

  test "should destroy job" do
    assert_difference('Job.count', -1) do
      delete :destroy, id: @job
    end

    assert_redirected_to jobs_path
  end
end
