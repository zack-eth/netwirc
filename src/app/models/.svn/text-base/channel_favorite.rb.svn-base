class ChannelFavorite < ActiveRecord::Base
  belongs_to  :user
  belongs_to  :channel
  attr_accessible :user_id, :channel_id
  validates_uniqueness_of :channel_id, :scope => :user_id

  def self.exists(user_id, channel_id)
    find(:first, :conditions => ["user_id = ? AND channel_id = ?", user_id, channel_id])
  end
  
end