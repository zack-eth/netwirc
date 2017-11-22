class MainController < ApplicationController

  layout 'general'
  
#  caches_action :check_for_events

  def index
    redirect_to(:controller => "channel", :action => "browse")
  end
  
  def select_tab
    @tab_list = get_tabs
    tab = nil
    if params[:type] == "channel"
        channel = Channel.find(params[:id])
        @tab_list.add_channel_tab(channel.id)
        tab = @tab_list.get_focus
    elsif params[:type] == "pm"
      private_message = PrivateMessage.find(params[:id])
      @tab_list.add_pm_tab(private_message.id, get_user.id)
      tab = @tab_list.get_focus
    elsif @tab_list.tabs.first[:id] == params[:id]
      tab = @tab_list.tabs.first
      @tab_list.set_focus(tab)
    end
    redirect_to(:controller => tab[:controller], :action => tab[:action], :id => tab[:id])
  end
  
  def select_main_tab
    @tab_list = get_tabs
    @tab_list.set_focus(@tab_list.tabs.first)
#    tab = @tab_list.get_focus
#    tab[:controller] = params[:c]
#    tab[:action] = params[:a]
#    tab[:id] = params[:i]
    redirect_to(:controller => params[:c], :action => params[:a], :id => params[:i])
  end
  
  def check_for_events
    event = EventListener.find(:first, :conditions => ["receiving_user_id = ? AND status_id = ?", params[:id], $STATUS_Pending]) rescue nil
#    for event in events
      if event.nil?
        return false
      end
      event.status_id = $STATUS_Confirmed
      event.save
      if event.event_listener_type_id == $EVENT_LISTENER_TYPE_Kick
        member = ChannelMember.find_by_user_id_and_channel_id(params[:id], event.channel_id)
        render :update do |page|
          page.redirect_to(:controller => "channel", :action => "leave", :id => event.channel_id)
        end
      end
      if event.event_listener_type_id == $EVENT_LISTENER_TYPE_Private_Message
        render :update do |page|
          page.redirect_to(:controller => "channel", :action => "private_msg", :id => event.private_message_id)
        end
#        return redirect_to(:controller => "channel", :action => "private_msg", :id => event.private_message_id)
      end
  end
  
  def ping
    user = get_user
    user.last_seen = Time.now
    user.save
    render(:nothing => true)   
  end
  
  def find_channel_results
    @results =  nil
    if params[:channel].size == 0 || params[:channel] == " "
      @results = []
    elsif params[:search][:by] == "name"
      @results =  Channel.find(:all, :conditions => ["channels.name LIKE ?", "%" + params[:channel] + "%"], :include => :picture)
    elsif params[:search][:by] == "topic"
      @results =  Channel.find(:all, :conditions => ["channels.topic LIKE ?", "%" + params[:channel] + "%"], :include => :picture)
    elsif params[:search][:by] == "description"
      @results =  Channel.find(:all, :conditions => ["channels.description LIKE ?", "%" + params[:channel] + "%"], :include => :picture)
    end 
  end
    
end