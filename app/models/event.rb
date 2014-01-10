class Event < ActiveRecord::Base
  attr_accessible :content, :date, :latitude, :longitude, :title
  belongs_to 	:user
  validates		:content, 	:length => { :maximum => 140 }
  validates 	:user_id, 	presence: true
end
