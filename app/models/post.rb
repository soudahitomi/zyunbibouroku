class Post < ApplicationRecord
  belongs_to :user
  has_many :lists, dependent: :destroy
  accepts_nested_attributes_for :lists, allow_destroy: true
end
