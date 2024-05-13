class Post < ApplicationRecord
  belongs_to :user
  has_many :lists, dependent: :destroy
  accepts_nested_attributes_for :lists, allow_destroy: true
  has_many :comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :notifications, as: :notifiable, dependent: :destroy

  validates :title, presence: true

  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end

  def self.search_for(word, method)
    if method == 'perfect'
      Post.where(title: word)
    elsif method == 'forward'
      Post.where('name LIKE ?', word + '%')
    elsif method == 'backward'
      Post.where('name LIKE ?', '%' + word)
    else
      Post.where('name LIKE ?', '%' + word + '%')
    end
  end
end
