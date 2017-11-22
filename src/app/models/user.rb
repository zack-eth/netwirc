require "digest/sha1"

class User < ActiveRecord::Base
  
  validates_acceptance_of :agreement,
                          :message => "You must read and accept the terms of the User Agreement to proceed",
                          :on => :create
  
  has_many    :channel_flags
  has_many    :memberships, :class_name => "ChannelMember"
  has_many    :channel_transcripts
  
  has_many    :meeting_attendences, :class_name => "MeetingAttendee"
  has_many    :meeting_transcripts

  has_many    :private_message_transcripts
  
  has_many    :channel_favorites
  
  has_one    :picture, :class_name => "UserPicture"
  
  has_many    :event_listeners
  
  attr_accessor :password
#  attr_accessible :name, :password, :first_name, :last_name, :email, :birthday, :zipcode

  validates_uniqueness_of :name
  validates_presence_of :name #, :password
  validates_format_of :email,          # field must match a regular expression
                      :with => /^([^@\s]+)@((?:[-a-z0-9]+.)+[a-z]{2,})$/i
  
  def before_create
    self.hashed_password = User.hash_password(self.password)
  end
  
  def after_create
    @password = nil
  end

  def is_guest?
    self.user_type_id == $USER_TYPE_Guest
  end
  
  def self.login(name, password)
    hashed_password = hash_password(password || "")
    find(:first,
          :conditions => ["name = ? and hashed_password = ?",
                            name, hashed_password])
  end
  
  def self.hash_password(password)
    Digest::SHA1.hexdigest(password)
  end
  
  def leave_all_channels
    memberships = ChannelMember.find(:all, :conditions => ["user_id = ? AND currently_in = 1", self.id])
    for member in memberships
      member.leave(nil)
    end
#    ChannelMember.delete_all(["user_id = ?", self.id])
#    rescue
  end
  
  def ping
    self.last_seen = Time.now
    self.save
  end
  
  def self.time_out
    users = find(:all, :conditions => ["last_seen < ? AND currently_on = true", 1.minute.ago])
    users.each { |u|
      u.leave_all_channels
    }
  end
  
end
