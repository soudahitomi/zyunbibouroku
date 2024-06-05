class Public::HomesController < ApplicationController

  def top
    if user_signed_in?
      redirect_to posts_path
    end

    if admin_signed_in?
      redirect_to admin_dashboards_path
    end
  end
end
