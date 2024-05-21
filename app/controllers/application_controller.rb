class Public::ApplicationController < ActionController::Base
  before_action :authenticate_user!, unless: :admin_controller?
  before_action :configre_permitted_parameters, if: :devise_controller?

  def after_sign_in_path_for(resource)
    posts_path
  end

  def after_sign_out_path_for(resource)
    posts_path
  end

  private

  def admin_controller?
    self.class.module_parent_name == 'Admin'
  end

  def configre_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up,keys:[:email])
  end
end
