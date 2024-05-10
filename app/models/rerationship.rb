class Rerationship < ApplicationRecord
  belongs_to :follower, class_name: "User"
  belongs_to :followerd, class_name: "User"
end
