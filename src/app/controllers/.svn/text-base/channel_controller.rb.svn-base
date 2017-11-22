class ChannelController < ApplicationController
  
  layout 'general'
  
#  caches_action :get_latest_messages
#  caches_action :get_last_channel_transcript_id
  caches_action :get_user_list
  caches_action :get_private_messages
  
  cache_sweeper :channel_transcript_sweeper
  cache_sweeper :private_message_transcript_sweeper
  cache_sweeper :channel_member_sweeper  

  def lookup
    if channel = Channel.find_by_name(params[:id])
      redirect_to(:action => "visit", :id => channel.id)
    else
      redirect_to(:action => "create", :id => params[:id])
    end
  end
  
  def visit
    if authorize(params[:id])
      @user = get_user
      @channel = Channel.find(params[:id])
      expire_action(:controller => "channel",
                    :action     => "get_user_list",
                    :id         => @channel.id)
      @channel_founder = ChannelMember.find(:first, :conditions => ["channel_id = ? and channel_member_role_id = ?", @channel.id, $CHANNEL_MEMBER_ROLE_Founder]) rescue nil
      @picture = ChannelPicture.find_by_channel_id(@channel.id)
      @member = @channel.members.find_by_user_id(@user.id)
      @is_favorite = @channel.favorites.find_by_user_id_and_channel_id(@user.id, @channel.id)
      @member.join(get_tabs)
      session[params[:id]] = nil
      @is_op = is_authorized?(get_user_id, params[:id])
    else
      @is_op = false
    end
  end
  
  def my_channels
    @user = get_user
    @founded_memberships = ChannelMember.find(:all, :conditions => ["user_id = ? AND channel_member_role_id = ?", @user.id, $CHANNEL_MEMBER_ROLE_Founder], :include => :channel)
    @opped_memberships = ChannelMember.find(:all, :conditions => ["user_id = ? AND channel_member_role_id = ?", @user.id, $CHANNEL_MEMBER_ROLE_Op], :include => :channel)
    @channel_favorites = ChannelFavorite.find(:all, :conditions => ["user_id = ?", @user.id], :include => :channel)
    @recently_visited = ChannelMember.find(:all, :conditions => ["user_id = ?", @user.id], :order => "last_seen DESC", :include => :channel)
  end
    
  def manage_ops
    check_for_ops(get_user_id, params[:id], "Sorry, you do not have access to this channel's op list.", {:action => 'visit', :id => params[:id]})
    channel_id = params[:id]
    @channel = Channel.find(channel_id)
    @ops = ChannelMember.find(:all, :conditions => ["channel_id = ? AND channel_member_role_id = ?", @channel.id, $CHANNEL_MEMBER_ROLE_Op], :include => :user)
  end
  
  def manage_ops_add
    channel_id = params[:channel_id]
    @channel = Channel.find(channel_id)
    op_id = params[:op_id]
    @op = User.find(op_id)
    @already_opped = false
    @member = ChannelMember.find_by_channel_id_and_user_id(@channel.id, @op.id) rescue nil
    if @member.nil?
      ChannelMember.create(:channel_id => @channel.id,
                              :user_id => @op.id,
                              :channel_member_role_id => $CHANNEL_MEMBER_ROLE_Op,
                              :currently_in => 0)
    else      
      if @member.channel_member_role_id == $CHANNEL_MEMBER_ROLE_Op
        @already_opped = 1        
      else
        @member.channel_member_role_id = $CHANNEL_MEMBER_ROLE_Op
        @member.save
      end
    end
    @memberships = ChannelMember.find(:all, :conditions => ["channel_id = ? AND channel_member_role_id = ?", @channel.id, $CHANNEL_MEMBER_ROLE_Op], :include => :user)
    render(:layout => false)
  end
  
  def manage_ops_remove
    channel_id = params[:channel_id]
    @channel = Channel.find(channel_id)
    op_id = params[:op_id]
    @op = User.find(op_id)
    @member = ChannelMember.find_by_channel_id_and_user_id(@channel.id, @op.id)
    @member.channel_member_role_id = $CHANNEL_MEMBER_ROLE_Basic
    @member.save
    @memberships = ChannelMember.find(:all, :conditions => ["channel_id = ? AND channel_member_role_id = ?", @channel.id, $CHANNEL_MEMBER_ROLE_Op], :include => :user)
    render(:layout => false)
  end

  def manage_ops_search
    @channel_id = params[:channel_id]
    @phrase = request.raw_post || request.query_string
    matcher = Regexp.new(@phrase, Regexp::IGNORECASE)
    user = get_user
    users = User.find(:all, :conditions => ["user_type_id <> ? AND id <> ?", $USER_TYPE_Guest, user.id])  # CANT OP GUESTS OR SELF
    @results =  users.find_all { |user| matcher =~ user.name }
    render(:layout => false)
  end

  def manage_bans
    check_for_ops(get_user_id, params[:id], "Sorry, you do not have access to this channel's ban list.", {:action => 'visit', :id => params[:id]})
    channel_id = params[:id]
    @channel = Channel.find(channel_id)
    @bans = ChannelMember.find(:all, :conditions => ["channel_id = ? AND channel_member_role_id = ?", @channel.id, $CHANNEL_MEMBER_ROLE_Banned], :include => :user)
  end
  
  def manage_bans_add
    channel_id = params[:channel_id]
    @channel = Channel.find(channel_id)
    banned_id = params[:banned_id]
    @banned = User.find(banned_id)
    @already_banned = false
    @member = ChannelMember.find_by_channel_id_and_user_id(@channel.id, @banned.id) rescue nil
    if @member.nil?
      ChannelMember.create(:channel_id => @channel.id,
                              :user_id => @banned.id,
                              :channel_member_role_id => $CHANNEL_MEMBER_ROLE_Banned,
                              :currently_in => 0)
    else      
      if @member.channel_member_role_id == $CHANNEL_MEMBER_ROLE_Banned
        @already_banned = 1        
      else
        @member.channel_member_role_id = $CHANNEL_MEMBER_ROLE_Banned
        @member.save
      end
    end
    @memberships = ChannelMember.find(:all, :conditions => ["channel_id = ? AND channel_member_role_id = ?", @channel.id, $CHANNEL_MEMBER_ROLE_Banned], :include => :user)
    render(:layout => false)
  end
  
  def manage_bans_remove
    channel_id = params[:channel_id]
    @channel = Channel.find(channel_id)
    banned_id = params[:banned_id]
    @banned = User.find(banned_id)
    @member = ChannelMember.find_by_channel_id_and_user_id(@channel.id, @banned.id)
    @member.channel_member_role_id = $CHANNEL_MEMBER_ROLE_Basic
    @member.save
    @memberships = ChannelMember.find(:all, :conditions => ["channel_id = ? AND channel_member_role_id = ?", @channel.id, $CHANNEL_MEMBER_ROLE_Op], :include => :user)
    render(:layout => false)
  end

  def manage_bans_search
    @channel_id = params[:channel_id]
    @phrase = request.raw_post || request.query_string
    matcher = Regexp.new(@phrase, Regexp::IGNORECASE)
    user = get_user
    users = User.find(:all, :conditions => ["user_type_id <> ? AND id <> ?", $USER_TYPE_Guest, user.id])  # CANT BAN GUESTS OR SELF
    @results =  users.find_all { |user| matcher =~ user.name }
    render(:layout => false)
  end

  #actively kick/ban user
  def kick(member_id = nil)
    member = ChannelMember.find(member_id || params[:member_id])
    if ChannelMember.find(:first, :conditions => ["user_id = ? AND channel_id = ? AND (channel_member_role_id = ? OR channel_member_role_id = ? OR channel_member_role_id = ?)", get_user_id, member.channel.id, $CHANNEL_MEMBER_ROLE_Op, $CHANNEL_MEMBER_ROLE_Founder, $CHANNEL_MEMBER_ROLE_Admin])
      ChannelTranscript.system_msg(member.channel.id, member.user.name + " has been kicked")
      EventListener.create(:event_listener_type_id => $EVENT_LISTENER_TYPE_Kick,
                            :channel_id => member.channel.id,
                            :receiving_user_id => member.user.id,
                            :status_id => $STATUS_Pending)
  #    render(:nothing => true)
    end
  end
  
  def ban
    user = get_user
    member = ChannelMember.find(:first, :conditions => ["user_id = ? AND channel_id = ?", params[:user_id], params[:channel_id]])
    member.ban(user)
  end
  
  def search
  end

  def browse
    @top_10 = Channel.find_by_sql(["select channels.id AS id, channels.name AS name, count(channel_members.user_id) AS qty from channels, channel_members, users where channels.id = channel_members.channel_id and channels.channel_access_id <> ? and channel_members.currently_in = 1 and channel_members.user_id = users.id and (channels.channel_access_id = ? or users.user_type_id <> ?) group by channel_id order by qty desc limit 10", $CHANNEL_ACCESS_Invite_Only, $CHANNEL_ACCESS_Public, $USER_TYPE_Guest])
    @top_favorites = Channel.find_by_sql(["select channels.id AS id, channels.name AS name, count(channel_favorites.id) AS qty from channels, channel_favorites where channels.id = channel_favorites.channel_id AND channels.channel_access_id <> ? GROUP BY channel_id ORDER BY qty DESC LIMIT 10", $CHANNEL_ACCESS_Invite_Only])
    @categories = ChannelCategory.find_all
  end
  
  def settings
    @channel = Channel.find(params[:id])
  end
  
  def edit_settings
    check_for_ops(get_user_id, params[:id], "Sorry, you do not have access to channel settings.", {:action => 'visit', :id => params[:id]})
    if request.get?
      @channel = Channel.find(params[:id])
      @categories = ChannelCategory.find(:all, :order => "name")
    else
      channel = Channel.find(params[:id])
      channel.name = params[:channel][:name]
      channel.topic = params[:channel][:topic]
      channel.description = params[:channel][:description]
      channel.category = ChannelCategory.find(params[:channel][:category])
      channel.status = Status.find(2)
      channel.save
      redirect_to(:action => :settings, :id => channel.id)
    end
  end
  
  def category
    @channels = Channel.find(:all, :conditions => ["channel_category_id = ? and channels.channel_access_id <> ?", params[:id], $CHANNEL_ACCESS_Invite_Only])
    @category = ChannelCategory.find(params[:id])
  end
  
  def create
    block_guests("Guests are not allowed to create channels.  Please register and/or log in.")
    if request.get?
      @channel = Channel.new
      @channel.name = params[:id]
      @categories = ChannelCategory.find(:all, :order => "name")
    else
      user = get_user
      channel = Channel.new
      channel.name = params[:channel][:name]
      channel.topic = params[:channel][:topic]
      channel.description = params[:channel][:description]
      channel.category = ChannelCategory.find(params[:channel][:category])
      channel.status = Status.find(2)
      if channel.save
        ChannelMember.create(
          :channel_id => channel.id,
          :user_id => user.id,
          :channel_member_role_id => $CHANNEL_MEMBER_ROLE_Founder,
          :currently_in => 0)
          redirect_to(:controller => "channel", :action => "visit", :id => channel.id)
      end
    end
  end

  def invite
    @channel = Channel.find(params[:id])
  end

  # Post a user's message to a channel
  def say
    user_id = params[:user_id]
    channel = Channel.find(params[:channel_id])
    member = channel.members.find_by_user_id(user_id)
    message = params[:message]
    return false unless message
    member.say(message)
    render :layout => false
  end

  def get_last_channel_transcript_id(channel_id)
    ChannelTranscript.find(:first, :conditions => ["channel_id = ?", channel_id], :order => 'id desc').id
  end

  def check_for_messages
    channel_id = params[:id]
    last_message_received = session[channel_id] || ChannelTranscript.find(:all, :conditions => ["channel_id = ?", channel_id], :limit => 11, :order => 'id desc').last.id
    last_message_sent = get_last_channel_transcript_id(channel_id) || 0
    @check_for_messages = nil
    if last_message_received != last_message_sent 
      session[channel_id] = last_message_sent
      channel = Channel.find(params[:id])
      user = get_user
      @check_for_messages = ChannelTranscript.find(:all, :conditions => ["id > ? AND channel_id = ?", last_message_received, channel.id], :order => 'id')
    end
  end
  
  # Get a list of users for the channel and clean up any who left
  def get_user_list
    channel = Channel.find(params[:id])
    user_list = ChannelMember.find(:all, :conditions => ["channel_id = ? AND currently_in = 1", channel.id], :order => "channel_member_role_id DESC")
    render(:partial => 'channel/chat_room_member_list', :object => user_list, :layout => false)
  end
  
  def search_by_name_results
    @phrase = request.raw_post || request.query_string
    matcher = Regexp.new(Regexp.escape(@phrase), Regexp::IGNORECASE)
    channels = Channel.find_all
    @results =  channels.find_all { |channel| matcher =~ channel.name }
    render(:layout => false)
  end
  
  def search_by_topic_results
    @phrase = request.raw_post || request.query_string
    matcher = Regexp.new(Regexp.escape(@phrase), Regexp::IGNORECASE)
    channels = Channel.find_all
    @results =  channels.find_all { |channel| matcher =~ channel.topic }
    render(:layout => false)
  end
  
  def search_by_description_results
    @phrase = request.raw_post || request.query_string
    matcher = Regexp.new(Regexp.escape(@phrase), Regexp::IGNORECASE)
    channels = Channel.find_all
    @results =  channels.find_all { |channel| matcher =~ channel.description }
    render(:layout => false)
  end

#  def search_pm_results
#    @channel_id = params[:channel_id]
#    @phrase = request.raw_post || request.query_string
#    matcher = Regexp.new(@phrase, Regexp::IGNORECASE)
#    users = User.find(:all, :conditions => "guest = 0")
#    @results =  users.find_all { |user| matcher =~ user.name }
#    render(:layout => false)
#  end

  def upload_picture 
  if request.get?
  else
    channel_id = params[:id]
    if picture = ChannelPicture.find_by_channel_id(channel_id)
      picture.destroy
    end
    picture = ChannelPicture.new(params[:picture])
    picture.channel_id = channel_id
    if picture.save
      redirect_to(:action => :settings, :id => channel_id)
    else
      flash[:error] = "Invalid picture."
      render(:action => :upload_picture)
    end
  end
  
  end
  
  def picture
    if picture = ChannelPicture.find(params[:id])
      send_data(picture.data,
#              :filename => picture.name,
              :type => picture.content_type,
              :disposition => "inline")
    else
      render(:nothing => true)
    end
  end

  def leave #######
    if params[:type] == "pm"
      private_message = PrivateMessage.find(params[:id])
      tab_list = get_tabs
      tab_to_close = nil
      for tab in tab_list.tabs
        if tab[:id] == private_message.id
          tab_to_close = tab
        end
      end 
      previous_tab = tab_list.get_previous_tab(tab_to_close)
      PrivateMessageTranscript.system_msg(private_message.id, get_user.name + " has closed this session")
      tab_list.remove_tab(tab_to_close[:name])
      redirect_to(:controller => "main", :action => "select_tab", :id => previous_tab[:id], :type => previous_tab[:type])
    else     
      channel = Channel.find(params[:id])
      member = ChannelMember.find_by_channel_id_and_user_id(channel.id, get_user_id)
      tab_list = get_tabs
      tab_to_close = nil
      for tab in tab_list.tabs
        if tab[:type] == "channel" && tab[:id] == channel.id
          tab_to_close = tab
        end
      end 
      previous_tab = tab_list.get_previous_tab(tab_to_close)
      member.leave(tab_list)
  #    tab_list.set_focus(previous_tab)
      tab_list.remove_tab(tab_to_close[:name])
      redirect_to(:controller => "main", :action => "select_tab", :id => previous_tab[:id], :type => previous_tab[:type])
    end
  end

  def logs_by_day
    channel_id = params[:id]
    @channel = Channel.find(channel_id)
    @date_query = ChannelTranscript.find_by_sql(["SELECT DISTINCT DATE_FORMAT(created_at, '%c/%e/%Y') AS date FROM channel_transcripts WHERE channel_id = ? ORDER BY created_at DESC", @channel.id])
  end

  def logs
    channel_id = params[:id]
    date = params[:date]
    @logs = ChannelTranscript.find(:all, :conditions => ["channel_id = ? AND DATE_FORMAT(channel_transcripts.created_at, '%c/%e/%Y') = ?", channel_id, date], :order => 'id', :include => {:user => [:picture]})
  end

  def add_to_favorites
#    if block_guests("Guests are not allowed to save favorite channels.  Please register and/or log in.")
    @channel = Channel.find(params[:channel_id])
    @user = User.find(params[:user_id])
    favorite = ChannelFavorite.new
    favorite.channel_id = @channel.id
    favorite.user_id = @user.id
    favorite.save
    render(:layout => false)
#    end
  end
  
  def remove_from_favorites
#    if block_guests("Guests are not allowed to save favorite channels.  Please register and/or log in.")
    @channel = Channel.find(params[:channel_id])
    @user = User.find(params[:user_id])
    ChannelFavorite.destroy_all(["channel_id = ? AND user_id = ?", @channel.id, @user.id])
    render(:layout => false)
#  end
  end
  
  def remove_favorite
    @channel = Channel.find(params[:channel_id])
    @user = User.find(params[:user_id])
    ChannelFavorite.destroy_all(["channel_id = ? AND user_id = ?", @channel.id, @user.id])
    @updated_favorites = ChannelFavorite.find(:all, :conditions => ["channel_favorites.user_id = ?", @user.id], :include => :channel) 
    render(:layout => false)
  end

  def pm_invite(r_id = nil)
    recipient_id = r_id || params[:user_id]
    user = get_user
    recipient = User.find(recipient_id)
    private_message = PrivateMessage.new
    private_message.requester_id = user.id
    private_message.requestee_id = recipient.id
    private_message.status_id = $STATUS_Pending
    private_message.save
    event = EventListener.new
    event.event_listener_type_id = $EVENT_LISTENER_TYPE_Private_Message
    event.private_message_id = private_message.id
    event.sending_user_id = user.id
    event.receiving_user_id = recipient.id
    event.status_id = $STATUS_Pending
    event.save
    redirect_to(:controller => "channel", :action => "private_msg", :id => private_message.id) and return
  end
  
  def private_msg    
    @private_message = PrivateMessage.find(params[:id])
    @with = nil
    if @private_message.requester_id == get_user.id
      @with = User.find(@private_message.requestee_id)
    else
      @with = User.find(@private_message.requester_id)
    end
    tab_list = get_tabs
    tab_list.add_pm_tab(@private_message.id, get_user.id)
  end

  def get_private_messages
    session[:last_retrieval] = 24.hours.ago
    private_message_id = params[:id]
    messages = PrivateMessageTranscript.find(:all, :conditions => ["private_message_id = ? AND private_message_transcripts.created_at >= ?", private_message_id, session[:last_retrieval]]) #, :include => {:user => [:picture]})
    render(:partial => 'channel/private_messages', :object => messages, :layout => false)
  end
  
  def pm_say
    private_message_id = params[:private_message_id]
    message = params[:message]
    return false unless message
    PrivateMessageTranscript.user_msg(private_message_id, get_user.id, message)
    render :layout => false
  end
  
  def flag
    if request.get?
      @channel_id = params[:id]
      @channel = Channel.find(@channel_id)
    else
      flag = ChannelFlag.new
      flag.channel_id = params[:id]
      flag.user_id = get_user.id
      flag.reason = params[:flag][:reason]
      flag.save
      num_flags = ChannelFlag.count_by_sql(["SELECT COUNT(DISTINCT user_id) FROM channel_flags WHERE channel_id = ?", flag.channel_id])
      if num_flags > 10
        channel = Channel.find(flag.channel_id)
        channel.status_id = $STATUS_Suspended
        channel.save
      end
      redirect_to(:action => :visit, :id => params[:id])
    end
  end

  def perform_act
      n = params["x"].size
      i = 0
      str = ""
      while i < n
        member_id = params["x"][i.to_s].to_i
        if member_id > 0
          case params[:act_type]
            when "kick"
              kick(member_id)
            when "ban"
              member = ChannelMember.find(member_id)
              member.channel_member_role_id = $CHANNEL_MEMBER_ROLE_Banned
              member.save
              kick(member.id)
            when "pm"
              recipient_id = ChannelMember.find(member_id).user.id
              user = get_user
              recipient = User.find(recipient_id)
              private_message = PrivateMessage.new
              private_message.requester_id = user.id
              private_message.requestee_id = recipient.id
              private_message.status_id = $STATUS_Pending
              private_message.save
              event = EventListener.new
              event.event_listener_type_id = $EVENT_LISTENER_TYPE_Private_Message
              event.private_message_id = private_message.id
              event.sending_user_id = user.id
              event.receiving_user_id = recipient.id
              event.status_id = $STATUS_Pending
              event.save
              event = EventListener.new
              event.event_listener_type_id = $EVENT_LISTENER_TYPE_Private_Message
              event.private_message_id = private_message.id
              event.sending_user_id = recipient.id
              event.receiving_user_id = user.id
              event.status_id = $STATUS_Pending
              event.save              
          end
        end
        i += 1
      end
#      redirect_to(:action => params[:act_type], :stuff => str) and return
      render(:nothing => true)
#    redirect_to(:action => params[:action]) and return
  end

  private ########### HELPER METHODS ###########
  
  def cannot_join(channel, reason, c, a, i)
    flash[:notice] = reason
    tab_list = get_tabs
    tab_list.remove_tab_by_title(channel.name)
    tab_list.set_focus_title(tab_list.tabs.first[:title])
    redirect_to(:controller => c, :action => a, :id => i)
  end

  def authorize(channel_id)
    channel = Channel.find(channel_id) rescue nil
    if channel.nil?
      redirect_to_home
      return false
    end
    if channel.status_id == $STATUS_Suspended
      flash[:notice] = "This channel has been suspended.  Please ensure that you have read the Terms & Conditions.  If you believe there has been an error, email us and we will look into it."
      redirect_to_home
    end
    user = get_user
    member = channel.members.find_by_user_id(user.id) rescue nil
    if member.nil?
      member = channel.members.create(:channel_id => channel.id,
                              :user_id => user.id,
                              :channel_member_role_id => $CHANNEL_MEMBER_ROLE_Basic,
                              :currently_in => 0)
    end
    if member.channel_member_role_id == $CHANNEL_MEMBER_ROLE_Banned
      flash[:notice] = "You are banned from this channel."
      redirect_to_home
      return false
    end
    if (channel.channel_access_id == $CHANNEL_ACCESS_Invite_Only)
      unless (member.channel_member_role_id == $CHANNEL_MEMBER_ROLE_Invited) || (member.channel_member_role_id == $CHANNEL_MEMBER_ROLE_Op) || (member.channel_member_role_id == $CHANNEL_MEMBER_ROLE_Founder) || (member.channel_member_role_id == $CHANNEL_MEMBER_ROLE_Admin)
        flash[:notice] = "This channel is invite only."
        redirect_to_home
        return false
      end
    end
    return true
  end

end
