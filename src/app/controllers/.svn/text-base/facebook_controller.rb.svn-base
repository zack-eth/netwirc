require 'facebook_web_session'

class FacebookController < ApplicationController

  $API_KEY = '0f8f626a5c74a1f97155947ee4df3f63'
  $API_SECRET = '96d3c1a256ad353ffe6e400f232a30f2'
  
#  layout 'facebook'
  
  def redirect_to_facebook_login
    session[:facebook_session] = FacebookWebSession.new($API_KEY, $API_SECRET)
    redirect_to session[:facebook_session].get_login_url
  end
  
  def callback
    
#    @fb_sig = params[:fb_sig]
#    @fb_sig_user = params[:fb_sig_user]
#    @fb_sig_session_key = params[:fb_sig_session_key]
    
#    begin
#       fbsession.activate_with_token(@fb_sig)
#    rescue # FacebookSession::RemoteException => e
#       flash[:error] = 'An exception occurred while trying to authenticate with Facebook'
#    end

#    @uid = session[:facebook_session].session_uid || 'test_uid'
#    myReponse = session[:facebook_session].users_getInfo({:uids => [@uid], :fields => ['name']})
#    @name = myReponse.search("//name").inner_html || 'test_name'
#    @name = 'test_name'
    
#    render :controller => 'channel', :action => 'visit', :id => 102
#    render :text => @fb_sig_user
    render :layout => false
    
  end
  
end