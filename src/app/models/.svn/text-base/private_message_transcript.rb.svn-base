class PrivateMessageTranscript < ActiveRecord::Base
  belongs_to :user
  belongs_to :private_message
  
  def self.system_msg(private_message_id, comment)
    create(:system_generated => true, :private_message_id => private_message_id, :comment => comment)
  end
  
  def self.user_msg(private_message_id, user_id, comment)
    create(:system_generated => false, :private_message_id => private_message_id, :user_id => user_id, :comment => comment)
  end
  
end