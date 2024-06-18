class Public::NotificationsController < ApplicationController

    def index
      @notifications = current_user.notifications.order(create_at: :desc).page(params[:page]).per(10)
      @notifications.update_all(read: true)
    end

    def update
      notification = current_user.notifications.find(params[:id])
      notification.update(read: true)
      case notification.notifiable_type
      when "Comment"
        redirect_to post_path(notification.notifiable.post)
      when "Favorite"
        redirect_to post_path(notification.notifiable.post)
      when "Relationship"
        redirect_to user_path(notification.notifiable)
      end
    end
end
