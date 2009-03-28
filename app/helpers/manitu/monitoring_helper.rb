module Manitu::MonitoringHelper
  
    def site_content_id(site)
      "site_content_#{site.id}"      
    end
    
    def site_bar_id(site)
      "site_bar_#{site.id}"
    end
    
    def site_progress_id(site)
      "site_progress_#{site.id}"
    end
    
    def site_indicator_id(site)
      "site_indicator_#{site.id}"
    end    
    
    def site_state_info(site)
      name = "site_state_#{site.state}"
      "Stav: " + render(:partial => name, :locals => { :site => site } )
    end
    
    def site_title_id(site)
      "site_title_#{site.id}"
    end
    
    def show_progress(site)
      hide(site_bar_id(site))+visual_effect(:appear, site_progress_id(site))
    end
    
    def check_add_form_id(site)
      "add_check_form_#{site.id}"
    end
    
    def check_add_form_help_id(site)
      "add_check_form_#{site.id}_help"
    end
    
    def check_add_form_error_id(site)
      "add_check_form_#{site.id}_error"
    end
    
    def show_bar(site)
      hide(site_progress_id(site))+show(site_bar_id(site))
    end
    
    def reset_ui(site)
      visual_effect(:highlight, site_title_id(site))+hide(site_bar_id(site))+hide(site_progress_id(site))
    end
  
    def check_row_id(check)
      "check_row_#{check.id}"
    end
    
    def site_list(title, list, partial)
      render :partial => "site_list", 
             :locals => {
                :title => title,
                :list => list,
                :partial => partial
                }
    end
    
    def site_bar_link(site, to, opts, html_opts = nil)
      opts ||= {}
      html_opts ||= {}
      opts = { :update => site_bar_id(site),
          :before => show_progress(site),
          :complete => show_bar(site) }.merge(opts)
      link_to_remote to, opts, html_opts
    end
    
    def check_row_link(check, to, opts, html_opts = nil)
      opts ||= {}
      html_opts ||= {}
      opts = {
            :before => show(site_indicator_id(check.site)),
            :complete => visual_effect(:highlight, check_row_id(check)) + hide(site_indicator_id(check.site)),
            }.merge(opts)
      link_to_remote to, opts, html_opts
    end
    
end
