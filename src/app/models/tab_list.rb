class TabList
  attr_accessor :tabs
  
  def initialize
    @tabs = Array.new
    add_tab("Main", "main", "main", "index", nil, false)
    @current_tab = @tabs.first
  end
  
  def add_tab(name, type, controller, action, id, closeable)
    tab = nil
    if is_open(name)
      tab = get_tab_by_name(name)
    else
      tab = { :name => name, :type => type, :controller => controller, :action => action, :id => id, :closeable => closeable }
      @tabs << tab
    end
    set_focus(tab)
#    redirect_to(:controller => tab[:controller], :action => tab[:action], :id => tab[:id])
  end
  
  def add_channel_tab(channel_id)
    channel = Channel.find(channel_id)
    add_tab(channel.name, "channel", "channel", "visit", channel.id, true)
  end
  
  def add_pm_tab(private_message_id, my_id)
    private_message = PrivateMessage.find(private_message_id)
    with_id = nil
    if my_id == private_message.requester_id
      with_id = private_message.requestee_id
    elsif my_id == private_message.requestee_id
      with_id = private_message.requester_id
    end
    with = User.find(with_id)
    add_tab("PM with #{with.name}", "pm", "channel", "private_msg", private_message.id, true)
  end
  
  def remove_tab(name)
    tab = get_tab_by_name(name)
    if tab && tab[:closeable]
      previous_tab = get_previous_tab(tab)
      @tabs.delete(tab)
      set_focus(previous_tab)
    end
  end
  
  def get_focus
    @current_tab
  end
  
  def set_focus(tab)
    @current_tab = tab
  end
  
  def is_open(name)
    is_open = false
    @tabs.each {|t|
                if t[:name] == name
                  is_open = true
                end
              }
    is_open
  end
  def get_tab_by_name(name)
    tab = nil
    @tabs.each {|t|
                if t[:name] == name
                  tab = t
                end
                }
    tab
  end
  def get_previous_tab(tab)
    previous_tab = nil
    @tabs.each_with_index {|t, i|
                if t == tab
                  previous_tab = @tabs[i-1]
                end
                }
    previous_tab
  end  
end