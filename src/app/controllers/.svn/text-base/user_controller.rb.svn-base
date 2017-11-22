#require 'RMagick'

class UserController < ApplicationController

  layout 'general'

  def registration
    if request.get?
      @user = User.new
      @user.birthday = Time.now
    else
      user = User.new(params[:user])
      user.user_type_id = $USER_TYPE_Registered_User
      user.user_profile_access_id = $USER_PROFILE_ACCESS_Public
      user.user_private_message_access_id	= $USER_PRIVATE_MESSAGE_ACCESS_On
      user.currently_on = true
      user.last_seen = Time.now
      if user.save
#        WelcomeMailer.deliver_welcome(user)
        session[:user_id] = user.id
        user_channel = Channel.new
        user_channel.name = user.name
        user_channel.topic = user.name + "'s channel"
        user_channel.description = "Welcome to NETWIRC!  This channel was created for you using default settings.  Please take a moment to update these settings.  Then invite people to chat with you at http://www.netwirc.com/" + user.name
        user_channel.channel_access_id = $CHANNEL_ACCESS_Moderated
        user_channel.channel_category_id = $CHANNEL_CATEGORY_Personal_Social
        user_channel.status_id = $STATUS_Confirmed
        if user_channel.save
          member = user_channel.members.create(
            :channel_id => user_channel.id,
            :user_id => user.id,
            :channel_member_role_id => $CHANNEL_MEMBER_ROLE_Founder,
            :currently_in => 0)
            redirect_to(:controller => "main", :action => "select_main_tab", :c => "user", :a => "home")
        end
      end
    end
  end

#  def welcome_test
#    WelcomeMailer.deliver_welcome(get_user)
#    render(:text => "Check your email.")
#  end
  
#  def welcome
#    @channel = Channel.find(params[:id])
#  end
  
  def login
    if request.get?
      @user = User.new
      @user.name = ''
      @user.password = ''
    else
      user = User.login(params[:user][:name], params[:user][:password])
      if user
        if user.status_id == $STATUS_Suspended
          flash[:notice] = "This account has been suspended.  Please ensure that you have read the Terms & Conditions.  If you believe there has been an error, email us and we will look into it."
#          redirect_to_home
        else 
          get_user.leave_all_channels
          reset_session
          session[:user_id] = user.id
          user.last_seen = Time.now
          user.currently_on = true
          user.save
          for member in ChannelMember.find(:all, :conditions => ["user_id = ? AND (channel_member_role_id = ? OR channel_member_role_id = ?)", user.id, $CHANNEL_MEMBER_ROLE_Founder, $CHANNEL_MEMBER_ROLE_Op])
            member.join(get_tabs)
          end
          redirect_to(:controller => "main", :action => "select_main_tab", :c => "user", :a => "home")
        end
      else
        flash[:error] = "Invalid user / password combination."
      end
    end
  end
  
  def logout
    if user = get_user
      user.leave_all_channels
    end
    user.currently_on = false
    reset_session
    redirect_to(:controller => "main", :action => "select_main_tab", :c => "user", :a => "login")
  end
  
  def profile
    @user = User.find(params[:id])
    @current_channels = ChannelMember.find(:all, :conditions => ["user_id = ? AND currently_in = 1", @user.id])
    @founder_channels = ChannelMember.find(:all, :conditions => ["user_id = ? AND channel_member_role_id = ?", @user.id, $CHANNEL_MEMBER_ROLE_Founder])
  end
  
  def edit_profile
    if request.get?
      @user = User.find(get_user_id)
      if @user.birthday.nil?
        @user.birthday = Time.now.years_ago(21)   # SET TO SOMETHING BETTER
      end
    else
      user = User.find(params[:id])
      user.update_attributes(params[:user])
      user.save
      redirect_to(:controller => "user", :action => "profile", :id => user.id)
    end
  end

  def search
  end
  
  def search_login_results
    @phrase = request.raw_post || request.query_string
    matcher = Regexp.new(Regexp.escape(@phrase), Regexp::IGNORECASE)
    users = User.find(:all, :conditions => ["user_type_id <> ?", $USER_TYPE_Guest])
    @results =  users.find_all { |user| matcher =~ user.name }
    render(:layout => false)
  end
  
  def search_fullname_results
    @phrase = request.raw_post || request.query_string
    matcher = Regexp.new(Regexp.escape(@phrase), Regexp::IGNORECASE)
    users = User.find(:all, :conditions => ["user_type_id <> ? AND first_name IS NOT NULL AND last_name IS NOT NULL", $USER_TYPE_Guest])
    @results =  users.find_all { |user| matcher =~ user.first_name + " " + user.last_name }
    render(:layout => false)
  end
  
  def search_email_results
    @phrase = request.raw_post || request.query_string
    matcher = Regexp.new(Regexp.escape(@phrase), Regexp::IGNORECASE)
    users = User.find(:all, :conditions => ["user_type_id <> ?", $USER_TYPE_Guest])
    @results =  users.find_all { |user| matcher =~ user.email }
    render(:layout => false)
  end
  
  def upload_picture
    user = get_user
    if request.get?
    else
      if picture = UserPicture.find_by_user_id(user.id)
        picture.destroy
      end
      picture = UserPicture.new(params[:picture])
      picture.user_id = user.id
      if picture.save
        redirect_to(:action => :profile, :id => user.id)
      else
        flash[:error] = "Invalid picture."
        render(:action => :upload_picture)
      end
    end
  end
  
  def picture
    if picture = UserPicture.find(params[:id])
      send_data(picture.data,
#              :filename => picture.name,
              :type => picture.content_type,
              :disposition => "inline")
    else
      render(:nothing => true)
    end
  end

  def home
    redirect_to(:controller => "channel", :action => "visit", :id => 1)
  end
  
  def add_to_favorite_channels
    @user = get_user
    @favorite_channel = @user.favorite_channels.create(params)
    render(:text => "Bookmark added")
  end
  
  def remove_from_favorite_channels
    @user = get_user
    UserChannelFavorite.destroy_all(["user_id = ? AND channel_id = ?", @user.id, params[:channel_id]])
    render(:text => "Bookmark removed")
  end  

  def flag
    if request.get?
      @receiving_user_id = params[:id]
      @user = User.find(@receiving_user_id)
    else
      flag = UserFlag.new
      flag.receiving_user_id = params[:id]
      flag.sending_user_id = get_user.id
      flag.reason = params[:flag][:reason]
      flag.save
      num_flags = UserFlag.count_by_sql(["SELECT COUNT(DISTINCT sending_user_id) FROM user_flags WHERE receiving_user_id = ?", flag.receiving_user_id])
      if num_flags > 10
        user = User.find(flag.receiving_user_id)
        user.status_id = $STATUS_Suspended
        user.save
      end
      redirect_to(:action => :profile, :id => params[:id])
    end
  end
  
  def render_resized_image
    @photo = UserPictures.find(params[:id])

    maxw = 90
    maxh = 90
    aspectratio = maxw.to_f / maxh.to_f

    pic = Magick::Image.from_blob(@photo.image)[0]

    picw = pic.columns
    pich = pic.rows
    picratio = picw.to_f / pich.to_f

    if picratio > aspectratio then
            scaleratio = maxw.to_f / picw
    else
            scaleratio = maxh.to_f / pich
    end

    thumb = pic.resize(scaleratio)
    
#    @photo.thumbnail = thumb
    
#    @photo.save

    send_data(thumb,
#              :filename => picture.name,
            :type => "image",
            :disposition => "inline")

  end
  

end
