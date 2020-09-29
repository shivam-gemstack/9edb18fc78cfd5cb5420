class ApplicationController < ActionController::API

	rescue_from ::Exception, with: :error_occurred 

	def error_occurred(exception)
  	render json: {error: exception.message}.to_json, status: 500
  end


end
