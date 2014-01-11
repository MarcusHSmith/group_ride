class Event < ActiveRecord::Base
  attr_accessible :content, :date, :title, :longitude, :latitude, :address, :address_latitude, :address_longitude, :address_locality, :address_country
  belongs_to 	:user
  validates		:content, 	:length => { :maximum => 140 }
  validates 	:user_id, 	presence: true

  geocoded_by :address
  after_validation :geocode
end
