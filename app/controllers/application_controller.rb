class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound do
    render json: { error: 'No such record in Database; check params', status: :not_found }
  end

  rescue_from ActiveRecord::InvalidForeignKey do
    render json: { error: 'Foreign key constraint violation; remove dependent records first' }, status: :conflict
  end

  def catch_404
    raise ActionController::RoutingError.new(params[:path])
  end

  rescue_from ActionController::RoutingError do |exception|
    Rails.logger.error "Routing error occurred: #{exception}"
    render json: { error: 'No route matches; check routes', status: :no_route }
  end
end
