module ApplicationHelper
  
  def header_link
    if session[:user]
      link_to "Manitú.cz", :controller => "/manitu/monitoring"
    else
      link_to "Manitú.cz", :controller => "/about"
    end
  end
  
  def link_to_with_selected(name, opts)
    aditional_opts = {}
    selected = true
    opts.each do |key, val|
      if params[key] != val
        selected = false
        break
      end
    end
    aditional_opts[:class] = "selected" if selected
    link_to name, opts, aditional_opts
  end
  
  MOTTOS = [
    "hlídá vaše weby",
    "božský monitoring",
    "hlídá, když spíte",
    "vaše jistotota"
  ]
  
  def get_motto
    MOTTOS[rand(MOTTOS.size)]
  end
  
  def hide(elem_id)
    "Element.hide($('"+elem_id+"'));"
  end
  
  def show(elem_id)
    "Element.show($('"+elem_id+"'));"
  end
  
  def version
    render :file => "about/version.txt"
  end
end
