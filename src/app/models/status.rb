class Status < ActiveRecord::Base
  has_many  :channels
  has_many  :channel_friendships
  has_many  :channel_mergers
  has_many  :channel_relationships
  
  has_many  :event_listeners
  
  has_many  :meeting_attendees
end