class Admin::DashboardsController < ApplicationController
  layout 'admin'

  def index
    @users = Use.all
  end
end
