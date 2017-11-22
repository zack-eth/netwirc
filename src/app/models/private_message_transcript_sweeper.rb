class PrivateMessageTranscriptSweeper < ActionController::Caching::Sweeper
  observe PrivateMessageTranscript

  def after_create(private_message_transcript)
    expire_pm_transcripts(private_message_transcript.private_message.id)
  end
  
  private
  def expire_pm_transcripts(private_message_id)
    expire_action(:controller => "channel",
                  :action     => "get_private_messages",
                  :id         => private_message_id)
  end
  
end