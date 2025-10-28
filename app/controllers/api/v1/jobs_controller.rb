class Api::V1::JobsController < ApplicationController
  before_action :set_job, only: [:show, :update, :destroy]

  def index
    if params[:company_id]
      jobs = Company.find(params[:company_id]).jobs.where(deleted: false)
    else
      jobs = Job.where(deleted: false)
      jobs = jobs.where("name ILIKE ?", "%#{params[:name]}%") if params[:name].present?
      jobs = jobs.where("place ILIKE ?", "%#{params[:place]}%") if params[:place].present?
    end
    render json: { jobs: jobs }, except: [:id, :created_at, :updated_at]
  end

  def show
    render json: @job
  end

  def create
    job = Job.new(job_params)
    if job.save
      render json: job.as_json, status: :created
    else
      render json: { job: job.errors, status: :no_content }
    end
  end

  def update
    if @job.update(job_params)
      render json: @job
    else
      render json: @job.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @job.delete_job
    render json: { deleted_job: @job, code: 200, status: :success }, except: [:created_at, :updated_at]
  end

  private

  def set_job
    @job = Job.find(params[:id])
  end

  def job_params
    params.permit(:name, :place, :company_id)
  end
end


