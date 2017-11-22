class Channel < ActiveRecord::Base
  belongs_to  :status
  
  belongs_to  :category, :foreign_key => "channel_category_id", :class_name => "ChannelCategory"
  has_many    :flags, :class_name => "ChannelFlag"
  has_many    :members, :class_name => "ChannelMember"
  has_one     :picture, :class_name => "ChannelPicture"
  has_many    :transcripts, :class_name => "ChannelTranscript"
  
  has_many    :first_channel_event_listeners, :foreign_key => "first_channel_id", :class_name => "EventListener"
  has_many    :second_channel_event_listeners, :foreign_key => "first_channel_id", :class_name => "EventListener"  
  
  has_many    :favorites, :class_name => "ChannelFavorite"
  
  validates_uniqueness_of :name
  validates_presence_of :name
  
  def users_just_left
    User.find_by_sql(["SELECT u.* FROM users u, channels_users cu WHERE cu.last_seen < DATE_SUB(?, INTERVAL 1 MINUTE) AND cu.user_id = u.id AND cu.channel_id = ?", Time.now, self.id])
  end
  
end
