class List < ApplicationRecord
  acts_as_list
  belongs_to :post

  def self.search_for(word, method)
    if method == 'perfect'
      List.where(content: word)
    elsif method == 'forward'
      List.where('content LIKE ?', word + '%')
    elsif method == 'backward'
      List.where('content LIKE ?', '%' + word)
    else
      List.where('content LIKE ?', '%' + word + '%')
    end
  end
end
