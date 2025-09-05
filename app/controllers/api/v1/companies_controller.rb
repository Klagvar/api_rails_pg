class Api::V1::CompaniesController < ApplicationController
  before_action :set_company, only: [:show, :update, :destroy, :mark_deleted]

  def index
    companies = Company.all
    companies = companies.where("name ILIKE ?", "%#{params[:name]}%") if params[:name].present?
    companies = companies.where("location ILIKE ?", "%#{params[:location]}%") if params[:location].present?
    render json: companies
  end

  def show
    render json: @company
  end

  def create
    company = Company.new(company_params)
    if company.save
      render json: company.as_json, status: :created
    else
      render json: { company: company.errors, status: :no_content }
    end
  end

  def update
    if @company.update(company_params)
      render json: @company
    else
      render json: @company.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @company.destroy
    render json: { deleted_job: { id: @company.id, name: @company.name, location: @company.location }, code: 200, status: :success }
  end

  def mark_deleted
    if @company.deleted
      render json: { deleted_company: [], deleted_already: :not_modified }
    else
      @company.delete_company
      render json: { deleted_company: @company, code: 200, status: :success }, except: [:created_at, :updated_at]
    end
  end

  private

  def set_company
    @company = Company.find(params[:id])
  end

  def company_params
    params.permit(:name, :location)
  end
end


