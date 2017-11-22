# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def message_content(message)
    %(<div class="message {message.level}" id="message-{message.id}"><span class="time">#{message.created_at.strftime('%R')}</span> <span class="sender">#{message.user.name}</span> <span class="content">#{message.comment}</span></div>)
  end
  
  def guest?
    user = User.find(session[:user_id]) rescue nil
    user.nil? || user.is_guest?
  end
  
  def logged_in?
    user = User.find(session[:user_id]) rescue nil
    !user.nil? && !user.is_guest?
  end
  
  def find_history
    ChannelMember.find(:all, :conditions => ["user_id = ?", session[:user_id]], :order => "last_seen DESC", :limit => 10)
  end
  
  def find_popular
    Channel.find_by_sql(["select channels.id AS id, channels.name AS name, count(channel_members.user_id) AS qty from channels, channel_members, users where channels.id = channel_members.channel_id and channels.channel_access_id <> ? and channel_members.currently_in = 1 and channel_members.user_id = users.id and (channels.channel_access_id = ? or users.user_type_id <> ?) group by channel_id order by qty desc limit 10", $CHANNEL_ACCESS_Invite_Only, $CHANNEL_ACCESS_Public, $USER_TYPE_Guest])
  end
  
  def find_channel(x)
    Channel.find(x)
  end
  
end
