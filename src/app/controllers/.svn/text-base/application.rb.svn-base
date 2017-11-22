# Filters added to this controller will be run for all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  model :tab_list

  $CHANNEL_ACCESS_Public = 1
  $CHANNEL_ACCESS_Moderated = 2
  $CHANNEL_ACCESS_Invite_Only = 3
  $CHANNEL_CATEGORY_Arts_Entertainment = 1
  $CHANNEL_CATEGORY_Business_Finance = 2
  $CHANNEL_CATEGORY_Education_Schools = 3
  $CHANNEL_CATEGORY_Family_Home = 4
  $CHANNEL_CATEGORY_Health_Wellness = 5
  $CHANNEL_CATEGORY_Personal_Social = 6
  $CHANNEL_CATEGORY_Politics_Society = 7
  $CHANNEL_CATEGORY_Religion_Beliefs = 8
  $CHANNEL_CATEGORY_Science_Technology = 9
  $CHANNEL_CATEGORY_Sports_Recreation = 10
  $CHANNEL_MEMBER_ROLE_Banned = 1
  $CHANNEL_MEMBER_ROLE_Basic = 2 
  $CHANNEL_MEMBER_ROLE_Invited = 3 
  $CHANNEL_MEMBER_ROLE_Op = 4 
  $CHANNEL_MEMBER_ROLE_Founder = 5 
  $CHANNEL_MEMBER_ROLE_Admin = 6
  $EVENT_LISTENER_TYPE_Private_Message = 1
  $EVENT_LISTENER_TYPE_Kick = 2
  $EVENT_LISTENER_TYPE_Flagged_Out = 3
  $STATUS_Pending = 1
  $STATUS_Confirmed = 2
  $STATUS_Rejected = 3
  $STATUS_Suspended = 4
  $STATUS_Deleted = 5
  $USER_TYPE_Guest = 1
  $USER_TYPE_Registered_User = 2
  $USER_TYPE_System_Admin = 3
  $USER_PROFILE_ACCESS_Public = 1 
  $USER_PROFILE_ACCESS_Private = 2
  $USER_PRIVATE_MESSAGE_ACCESS_On = 1 
  $USER_PRIVATE_MESSAGE_ACCESS_Off = 2

  def redirect_to_home
    user = get_user
    if user && (user.user_type_id != $USER_TYPE_Guest)
      redirect_to(:controller => 'main', :action => 'select_main_tab', :c => 'user', :a => 'home')
    else
      redirect_to(:controller => 'main', :action => 'select_main_tab', :c => 'main', :a => 'index')
    end    
  end
  
  def get_user_id
    session[:user_id] rescue nil
  end
  
  def get_user
    user = User.find(session[:user_id]) rescue nil
    if user.nil?
      user = User.new
      user.name = "guest" + rand(1000000).to_s
      user.user_type_id = $USER_TYPE_Guest
      user.email = user.name + "@netwirc.com"
      user.birthday = 21.years.ago
      user.password = user.name
      user.user_profile_access_id = $USER_PROFILE_ACCESS_Public
      user.user_private_message_access_id = $USER_PRIVATE_MESSAGE_ACCESS_On
      user.currently_on = true
      user.last_seen = Time.now
      user.save
      session[:user_id] = user.id
    end
    user
  end
  
  def get_tabs
    session[:tabs] ||= TabList.new
  end
  
  def check_for_ops(user_id, channel_id, error_msg, url)
    unless is_authorized?(user_id, channel_id)
      flash[:notice] = error_msg
      session[channel_id] = nil
      redirect_to url
    end
  end
  def is_authorized?(user_id, channel_id) 
    ChannelMember.find(:first, :conditions => ["user_id = ? AND channel_id = ? AND (channel_member_role_id = ? OR channel_member_role_id = ? OR channel_member_role_id = ?)", user_id, channel_id, $CHANNEL_MEMBER_ROLE_Op, $CHANNEL_MEMBER_ROLE_Founder, $CHANNEL_MEMBER_ROLE_Admin])
  end

  def block_guests(error_msg)
    user = get_user
    if user && !user.is_guest?
      return true
    else
      flash[:notice] = error_msg
      session[1] = nil
      redirect_to :action => 'visit', :id => 1, :layout => false
      return false
    end
  end
  
end
