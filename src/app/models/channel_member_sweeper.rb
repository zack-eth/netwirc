class ChannelMemberSweeper < ActionController::Caching::Sweeper
  observe ChannelMember

  def after_save(channel_member)
    expire_channel_members(channel_member.channel.id)
#    expire_channel_transcripts(channel_member.channel.id)    
  end
  
  private
  def expire_channel_members(channel_id)
    expire_action(:controller => "channel",
                  :action     => "get_user_list",
                  :id         => channel_id)
  end
  def expire_channel_transcripts(channel_id)
    expire_action(:controller => "channel",
                  :action     => "get_latest_messages",
                  :id         => channel_id)
  end
  
end