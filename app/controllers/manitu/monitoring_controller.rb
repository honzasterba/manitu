class Manitu::MonitoringController < Manitu::BaseController
  
  def index
    @error_sites = act_account.sites_with_errors
    @other_sites = act_account.sites_without_errors
    @sites_count = @error_sites.size + @other_sites.size
  end
  
  def refresh_dashboard
    if params[:actual]
      date = Time.parse(params[:actual])
      @change = ( act_account.last_report and (date < act_account.last_report.created_at) )
    end    
    index
    render :partial => "dashboard_content"
  end
  
  def add_site
    @site = Site.new(params[:site])
    @site.account = act_account
    if @site.save
      flash[:notice] = "Monitoring přidán."
      redirect_to :action => "index"
    else
      index
      @site.errors.each { |attr, msg| flash[:error] = "Chyba v zadání: "+msg}
      render :action => "index"
    end
  end
  
  def edit_site
    @site = Site.find(params[:id])
    render :partial => "site_edit"
  end
  
  def update_site
    @site = Site.find(params[:id])
    @site.state = Site::STATE_NEW
    @site.update_attributes(params[:site])
    render :action => "site_update"
  end
  
  def confirm_site
    @site = Site.find(params[:id])
    @result = Manitu.confirm_site(@site)
    render :action => "site_confirm"
  end
  
  def refresh_site
    site = Site.find(params[:id])
    render :partial => "site_info", :locals => { :site => site }
  end
  
  def recheck_site
    site = Site.find(params[:id])
    Manitu.check_site(site) if site.state == Site::STATE_ERROR
    render :partial => "site_info", :locals => { :site => site }
  end
  
  def colapse_site
    site = Site.find(params[:id])
    render :partial => "site_info_short", :locals => { :site => site }
  end

  def destroy_site
    @site = Site.find(params[:id])
    @site.destroy
    flash[:notice] = "Doména smazána."
    redirect_to :action => "index"
  end

  def add_check
    @site = Site.find(params[:id])
    @new_check = Check.new(params[:check])
    @new_check.site = @site
    @new_check.save
    render :action => "check_add"
  end
  
  def show_check
    @check = Check.find(params[:id])
    render :action => "check_show"
  end
  
  def toggle_check
    @check = Check.find(params[:id])
    @check.active = !@check.active
    @check.save
    render :action => "check_show"
  end
  
  def edit_check
    @check = Check.find(params[:id])
    render :action => "check_edit"
  end
  
  def update_check
    @check = Check.find(params[:id])
    @saved = @check.update_attributes(params[:check])
    render :action => "check_update"
  end
  
  def destroy_check
    @check = Check.find(params[:id])
    if !@check.system?
      @check.destroy
      render :action => "check_destroy"
    else
      render :nothing
    end
  end
end
