class ChannelTranscriptSweeper < ActionController::Caching::Sweeper
  observe ChannelTranscript

  def after_create(channel_transcript)
    expire_channel_transcripts(channel_transcript.channel.id)
  end
  
  private
  def expire_channel_transcripts(channel_id)
#    expire_action(:controller => "channel",
#                  :action     => "get_latest_messages",
#                  :id         => channel_id)
#    expire_action(:controller => "channel",
#                  :action     => "get_last_channel_transcript_id",
#                  :channel_id         => channel_id)                  
  end
  
end