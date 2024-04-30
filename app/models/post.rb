class Post < ApplicationRecord
  belongs_to :user
  has_many :lists, dependent: :destroy
  accepts_nested_attributes_for :lists, allow_destroy: true
  has_many :comments, dependent: :destroy
  has_many :favorites, dependent: :destroy

  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end

  def self.search_for(word, method)
    if method == 'perfect'
      Book.where(title: word)
    elsif method == 'forward'
      Book.where('name LIKE ?', word + '%')
    elsif method == 'backward'
      Book.where('name LIKE ?', '%' + word)
    else
      Book.where('name LIKE ?', '%' + word + '%')
    end
  end
end
