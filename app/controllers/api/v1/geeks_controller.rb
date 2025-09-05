class Api::V1::GeeksController < ApplicationController
  before_action :set_geek, only: [:show, :update, :destroy]

  def index
    geeks = Geek.all
    geeks = geeks.where("name ILIKE ?", "%#{params[:name]}%") if params[:name].present?
    geeks = geeks.where("stack ILIKE ?", "%#{params[:stack]}%") if params[:stack].present?
    render json: geeks
  end

  def show
    render json: @geek
  end

  def create
    geek = Geek.new(geek_params)
    if geek.save
      render json: geek.as_json, status: :created
    else
      render json: { geek: geek.errors, status: :no_content }
    end
  end

  def update
    if @geek.update(geek_params)
      render json: @geek
    else
      render json: @geek.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @geek.destroy
    head :no_content
  end

  private

  def set_geek
    @geek = Geek.find(params[:id])
  end

  def geek_params
    params.permit(:name, :stack, :resume)
  end
end


