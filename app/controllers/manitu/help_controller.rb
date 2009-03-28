class Manitu::HelpController < Manitu::BaseController
  
  Item = Struct.new(:name, :link)
  
  MENU = [
    Item.new("Jak začít", "how_to_start"),
    Item.new("Ověření monitoringu", "confirmation")
  ]
  DEFAULT_HELP = MENU.first
  
  def index
    if !params[:names] or params[:names].empty?
      redirect_to :action => DEFAULT_HELP.link
      return
    end
    @menu = MENU
    name = params[:names].first
    if File.exist?(help_file_path(name))
      @help = name
    else
      flash[:error] = "Na toto téma nápověda neexistuje."
    end
  end
  
  protected
  
    def help_file_path(name)
      template_root + "/manitu/help/#{name}.textile"
    end
  
end
