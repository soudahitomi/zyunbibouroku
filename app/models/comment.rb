class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :post
  has_one :notification, as: :notifiable, dependent: :destroy

  validates :body, presence: true, length: { in: 1..140 }

  after_create do
    create_notification(user_id: post.user_id)
  end
end
