class ChannelTranscript < ActiveRecord::Base

  belongs_to  :channel
  belongs_to  :user
  
  def self.system_msg(channel_id, comment)
    create(:system_generated => true, :channel_id => channel_id, :comment => comment)
  end
  
  def self.user_msg(channel_id, user_id, comment)
    create(:system_generated => false, :channel_id => channel_id, :user_id => user_id, :comment => comment)
  end
  
end