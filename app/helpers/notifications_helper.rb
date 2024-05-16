module NotificationsHelper
  def notification_message(notification)
    case notification.notifiable_type
    when "Comment"
      "投稿した#{notification.notifiable.post.title}に#{notification.notifiable.user.name}さんがコメントしました"
    when "Favorite"
      "投稿した#{notification.notifiable.post.title}が#{notification.notifiable.user.name}さんにいいねされました"
    when "Relationship"
      "#{notification.notifiable.follower.name}が#{notification.notifiable.followed.name}さんをフォローました"
    end
  end
end
