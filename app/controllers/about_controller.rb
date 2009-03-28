class AboutController < ApplicationController
  
  layout "public"
  
  filter_parameter_logging :pass
  
  def index
    
  end
  
  def not_found
    render :action => "not_found", :status => 404
  end
  
  def rss
    if params[:id].blank?
      render :action => "not_found", :status => 404
      return
    end
    @user = User.find_by_token(params[:id])
    if @user
      @reports = Report.find_for_user(@user)
      render :action => "rss", :layout => false
    else
      render :action => "not_found", :status => 404
    end
  end
  
  def login
    if session[:user]
      redirect_to :controller => "manitu/monitoring"
      return
    end
    return if !params[:password] and !params[:email]
    u = User.find_by_email_and_password(params[:email], User.sha1(params[:password]))
    if u and u.state == User::CONFIRMED
      if params[:remember]
        cookies[:token] = { 
            :value => u.generate_remember, 
            :expires => 12.years.from_now, 
            :path => "/" }
      end
      session[:user] = u.id
      flash[:notice] = "Vítej zpět, #{u.nick}!"
      redirect_to :controller => "manitu/monitoring"
    elsif u.nil?
      flash[:error] = "Přilášení se nezdařilo."
      redirect_to :action => "login"
    elsif u.state == User::NEW
      flash[:error] = "Svůj účet musíš nejdříve aktivovat."
      redirect_to :action => "login"
    elsif u.state == User::BLOCKED
      flash[:error] = "Tvůj účet byl zablokován."
      redirect_to :action => "login"
    end
  end
  
  def register
    return if !params[:user]
    @user = User.new(params[:user])
    if @user.save
      if @user.send_welcome_mail(confirm_url(:only_path => false, :id => @user.token))
        flash.now[:notice] = "Registrace úspěšná."
        render :action => "after_register"
      else
        @user.destroy
        flash.now[:error] = "Při zakládání účtu došlo k chybě."
      end
    else
      @user.clear_passwords
      flash.now[:error] = "Chyba v zadání: #{@user.errors.first_message}"
    end
  end
  
  def after_register
  end
  
  def confirm
    if params[:id].blank?
      render :action => "not_found", :status => 404
      return
    end
    user = User.find_by_token(params[:id])
    if user.nil?
      flash[:error] = "Autorizace se nezdařila."
      redirect_to :action => "index"
    elsif user.confirm!
      flash[:notice] = "Autorizace úspěšná, můžeš se přihlásit."
      redirect_to :action => "login"
    else 
      flash[:error] = "Autorizace se nezdařila: #{user.errors.first_message}"
      redirect_to :action => "index"
    end
  end
  
  def forgot_password
    user = User.find_by_email(params[:email])
    if !user 
      flash[:error] = "Uživatel se zadaným emailem nebyl nalezen."
    else
      new_pass = user.reset_password!
      Notifier.deliver_forgot_password(user, new_pass)
      flash[:notice] = "Heslo bylo přenastaveno a odesláno na tvůj email."
    end
    redirect_to :action => "login"    
  end
end
