module Manitu::BaseHelper
  
  ACC_SEL_TOOLS = [["- - - - - - - - - - - - - - - - - - - - - - -", ""],["Přidat nový...", "0"]]
  
  def account_select
    list = act_user.accounts.collect {|a| [a.name, a.id]} + ACC_SEL_TOOLS
    opts = options_for_select list, act_account.id
    select_tag "account", opts, :id => "accountSelect", :onChange => "selectAccount();"
  end
  
  def render_help(name)
    output = render :file => "manitu/help/#{name}.textile"
    RedCloth.new(output).to_html
  end
  
end
