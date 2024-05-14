class List < ApplicationRecord
  acts_as_list
  belongs_to :post
end
