class Admin::DashboardsController < ApplicationController
  layout 'admin'

  def index
    @users = User.page(params[:page]).per(10)
  end
end
