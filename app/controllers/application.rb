class ApplicationController < ActionController::Base

  session :session_key => '_manitu_session_id'
    
  def logout
    if act_user
      act_user.clear_remember
    end
    session[:user] = nil
    session[:account] = nil
    cookies[:token] = nil
    flash[:notice] = "Byl jsi odhlášen. Nashledanou."
    redirect_to :controller => "/about"
  end  
  
  protected
  
    def act_user
      @act_user
    end
    helper_method :act_user
    
    before_filter :auto_login
    def auto_login
      return if session[:user]
      return if cookies[:token].blank?
      user = User.find_by_remember cookies[:token]
      if user
        session[:user] = user.id
        flash.now[:notice] = "Vítej zpět, #{user.nick}!"
        redirect_to "/manitu"
        return false
      else
        cookies[:token] = nil
      end
      return true
    end

    before_filter :load_from_session
    def load_from_session
      return true if session[:user].blank?
      @act_user = User.find session[:user]
      if session[:account]
        @act_account = Account.find(session[:account])
      else 
        @act_user.save if @act_user.accounts.empty? # creates default account
        @act_account = @act_user.accounts[0]
      end
      session[:account] = @act_account.id
      return true
    end

  

end
