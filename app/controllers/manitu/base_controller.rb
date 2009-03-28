class Manitu::BaseController < ApplicationController
  layout "manitu"
  
  def set_account
    session[:account] = params[:id]
    flash[:notice] = "Účet změněn."
    redirect_to :controller => "monitoring"
  end
  
  protected
  
    def act_account
      @act_account
    end
    helper_method :act_account
    
    before_filter :check_login
    def check_login
      if session[:user].blank?
        flash.now[:error] = "Nejdřív se musíš přihlásit."
        redirect_to :controller => "/about", :action => "login"
        return false
      end
      return true
    end

end
