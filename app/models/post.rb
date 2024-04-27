class Post < ApplicationRecord
  belongs_to :user
  has_many :lists, dependent: :destroy
  accepts_nested_attributes_for :lists, allow_destroy: true
  has_many :comments, dependent: :destroy
  has_many :favorites, dependent: :destroy

  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end
end
