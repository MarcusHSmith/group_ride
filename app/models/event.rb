class Event < ActiveRecord::Base
  attr_accessible :content, :name, :user_id
  belongs_to :user
  validates :content, :length => { :maximum => 500 }
end
