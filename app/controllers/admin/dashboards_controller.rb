class Admin::DashboardsController < ApplicationController
  layout 'admin'
  befor_action :authenticate_admin!

  def index
    @users = Use.all
  end
end
