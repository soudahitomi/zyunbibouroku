class ApplicationController < ActionController::Base
  before_action :configre_permitted_parameters, if: :devise_controller?

  def after_sign_in_path_for(resource)
    posts_path
  end

  private

    def configre_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up,keys:[:email])
    end
end
