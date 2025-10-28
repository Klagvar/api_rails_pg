class Api::V1::AppliesController < ApplicationController
  before_action :set_apply, only: [:show, :update, :destroy]

  def index
    applies = Apply.all
    # Filter by associations
    applies = applies.where(geek_id: params[:geek_id]) if params[:geek_id].present?
    applies = applies.where(job_id: params[:job_id]) if params[:job_id].present?
    if params[:company_id].present?
      applies = applies.joins(:job).where(jobs: { company_id: params[:company_id] })
    end
    applies = applies.where(read: ActiveModel::Type::Boolean.new.cast(params[:read])) if params.key?(:read)
    applies = applies.where(invited: ActiveModel::Type::Boolean.new.cast(params[:invited])) if params.key?(:invited)
    render json: applies
  end

  def show
    render json: @apply
  end

  def create
    apply = Apply.new(apply_params)
    if apply.save
      render json: apply.as_json, status: :created
    else
      render json: { apply: apply.errors, status: :no_content }
    end
  end

  def update
    if @apply.update(apply_params)
      render json: @apply
    else
      render json: @apply.errors, status: :unprocessable_entity
    end
  end

  def destroy
    deleted = { id: @apply.id, job_id: @apply.job_id, geek_id: @apply.geek_id }
    @apply.destroy
    render json: { deleted_apply: deleted, code: 200, status: :success }
  end

  private

  def set_apply
    @apply = Apply.find(params[:id])
  end

  def apply_params
    params.permit(:job_id, :geek_id, :read, :invited)
  end
end


