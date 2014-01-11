class Event < ActiveRecord::Base
  attr_accessible :content, :date, :title, :longitude, :latitude, :address, :address_latitude, :address_longitude, :address_locality, :address_country
  belongs_to 	:user
  validates		:content, 	:length => { :maximum => 140 }
  validates 	:user_id, 	presence: true
  default_scope order: 'events.created_at DESC'

  geocoded_by :address
  after_validation :geocode

  def self.from_users_followed_by(user)
  	followed_user_ids = "SELECT followed_id FROM relationships
  		WHERE follower_id = :user_id"
  	where("user_id IN (#{followed_user_ids}) OR user_id = :user_id",
  	    user_id: user)
  end  
end
