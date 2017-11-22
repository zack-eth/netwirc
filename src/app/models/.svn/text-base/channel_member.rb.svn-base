class ChannelMember < ActiveRecord::Base
  belongs_to  :channel
  belongs_to  :user
    
  def add_ban
    self.banned = 1
    self.save
  end
  
  def remove_ban
    self.banned = 0
    self.save
  end
  
  def cleanup
#    if self.user.last_seen && self.user.last_seen < 5.minutes.ago #!self.last_seen || self.last_seen < 5.minute.ago # change to only if logged_off!
#      self.currently_in = 0
#      self.save
#    end
  end
  
  def status
    if self.user.last_seen && self.user.last_seen > 1.minute.ago
      "active"
    elsif self.user.last_seen && self.user.last_seen > 5.minutes.ago
      "idle"
    else
      "inactive"
    end
  end

  def is_gone
    self.currently_in = 0
    self.save
  end
  
#  def kick
#    self.say_in_channel("has been kicked by #{user.name}")
#    self.currently_in = 0
#    self.save
#  end
  
  def ban(user)
    self.say_in_channel("has been banned by #{user.name}")
    self.banned = 1
    self.currently_in = 0
    self.save
  end
  
  def is_currently_in_channel?
    self.currently_in
  end
  
  def say(comment)
    ChannelTranscript.user_msg(self.channel.id, self.user.id, sanitize(comment))
  end

  def join(tab_list)
    if !self.is_currently_in_channel?
#      self.announce_joining
      self.currently_in = true
      self.last_seen = Time.now
      self.save
    end
    tab_list.add_channel_tab(self.channel.id)
  end
  
  def announce_joining
    if !(self.user.is_guest?)
      ChannelTranscript.system_msg(self.channel.id, (self.user.name + " has joined the channel"))
#      expire_action :action => "get_user_list", :id => self.channel.id
#      expire_action :action => "get_latest_messages", :id => self.channel.id
    elsif (self.user.is_guest?) && (self.channel.channel_access_id == $CHANNEL_ACCESS_Public)
#      expire_action :action => "get_user_list", :id => self.channel.id
    end
  end
  
  def leave(tab_list)
    self.is_gone
#    self.announce_leaving
#    Channel.expire_action :controller => "channel", :action => "get_user_list", :id => self.channel.id
#    Channel.expire_action :controller => "channel", :action => "get_latest_messages", :id => self.channel.id
  end
  
  def announce_leaving
    if !(self.user.is_guest?)
      ChannelTranscript.system_msg(self.channel.id, self.user.name + " has left the channel")
#      expire_action :controller => "channel", :action => "get_user_list", :id => self.channel.id
#      expire_action :controller => "channel", :action => "get_latest_messages", :id => self.channel.id
    elsif self.user.is_guest? && (self.channel.name == "lobby")
#      expire_action :controller => "channel", :action => "get_user_list", :id => self.channel.id
    end
  end
  
  def sanitize(say)
    say.gsub(/\</, '&lt;').gsub(/\>/, '&gt;')
  end
  
end
