class Location < ActiveRecord::Base
  attr_accessible :address
  geocoded_by :address
  after_validation :geocode, :if => :address_changed?
end
