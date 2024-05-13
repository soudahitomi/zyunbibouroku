class List < ApplicationRecord
  belongs_to :post
  acts_as_list
end
